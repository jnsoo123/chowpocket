require 'facebook/messenger'

include Facebook::Messenger

def set_user(id)
  ChatbotUser.where(facebook_id: id).first_or_create do |user|
    user.facebook_id = id
    user.state = 'REGISTRATION_1'
  end
end

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'GET_STARTED_PAYLOAD'
  }
}, access_token: ENV['ACCESS_TOKEN'])

Facebook::Messenger::Profile.set({
  persistent_menu: [
    {
      locale: 'default',
      composer_input_disabled: true,
      call_to_actions: [
        {
          title: 'My Account',
          type: 'nested',
          call_to_actions: [
            {
              title: 'Reset My Name and Contact info',
              type: 'postback',
              payload: 'RESET_ACCOUNT'
            }
          ]
        },
        {
          type: 'web_url',
          title: 'Our awesome website',
          url: 'https://chowpocket.herokuapp.com',
          webview_height_ratio: 'full'
        }
      ]
    }
  ]
}, access_token: ENV['ACCESS_TOKEN'])

Bot.on :message do |msg|
  puts msg.as_json
  fb_id = msg.sender['id']

  @user = set_user(fb_id)

  text = []
  options = {}

  case @user.state
  when 'REGISTRATION_1'
    text.push 'We are almost ready to launch! Enter your details below to be one of the first ones in! Sign up now!'
    text.push 'Please enter your name.'
    @user.update state: 'REGISTRATION_2'
  when 'REGISTRATION_2'
    options[:attachment] = {
      type: 'template',
      payload: {
        template_type: 'button',
        text: "Is your name '#{msg.text}'?",
        buttons: [
          { type: 'postback', title: 'Yes', payload: 'REGISTRATION_2_YES'},
          { type: 'postback', title: 'No', payload: 'REGISTRATION_2_NO' }
        ]
      }
    }
    @user.update name: msg.text
  when 'REGISTRATION_3'
    options[:attachment] = {
      type: 'template',
      payload: {
        template_type: 'button',
        text: "Is your contact number '#{msg.text}'?",
        buttons: [
          { type: 'postback', title: 'Yes', payload: 'REGISTRATION_3_YES'},
          { type: 'postback', title: 'No', payload: 'REGISTRATION_3_NO' }
        ]
      }
    }
    @user.update contact_number: msg.text
  when 'REGISTRATION_DONE'
    if msg.quick_reply.present?
      case msg.quick_reply
      when 'ORDER_HEAVY'
        text.push 'Put heavy menu here'
      when 'ORDER_LIGHT'
        text.push 'Put light menu here'
      end
    else
      options = {
        text: 'What would you like to order?',
        quick_replies: [
          {content_type: 'text', title: 'Heavy Meal', payload: 'ORDER_HEAVY'},
          {content_type: 'text', title: 'Light Diet', payload: 'ORDER_LIGHT'},
        ]
      }
    end
  else
    options = {
      text: 'What would you like to order?',
      quick_replies: [
        {content_type: 'text', title: 'Heavy Meal', payload: 'ORDER_HEAVY'},
        {content_type: 'text', title: 'Light Diet', payload: 'ORDER_LIGHT'},
      ]
    }
  end

  text.map do |t|
    msg.reply(text: t)
  end

  msg.reply(options) if options.present?
end

Bot.on :postback do |postback|
  puts postback.as_json

  fb_id = postback.sender['id']
  @user = set_user fb_id

  text = []
  options = {}
  
  case postback.payload
  when 'GET_STARTED_PAYLOAD'
    text.push 'We are almost ready to launch! Enter your details below to be one of the first ones in! Sign up now!'
    text.push 'Please enter your name.'
    @user.update state: 'REGISTRATION_2'
  when 'REGISTRATION_2_YES'
    text.push 'Please enter your contact info.'
    @user.update state: 'REGISTRATION_3'
  when 'REGISTRATION_2_NO'
    text.push 'Please enter your name.'
  when 'REGISTRATION_3_YES'
    text.push 'Congratulations! You have successfully registered on our store.'
    text.push 'You are ready to order.'
    options = {
      text: 'What would you like to order?',
      quick_replies: [
        {content_type: 'text', title: 'Heavy Meal', payload: 'ORDER_HEAVY'},
        {content_type: 'text', title: 'Light Diet', payload: 'ORDER_LIGHT'},
      ]
    }
    @user.update state: 'REGISTRATION_DONE'
  when 'REGISTRATION_3_NO'
    text.push 'Please enter your contact info.'
  when 'RESET_ACCOUNT'
    @user.update name: nil, contact_number: nil, state: 'REGISTRATION_2'
    text.push 'Please enter your name.'
  else
    options = {
      text: 'What would you like to order?',
      quick_replies: [
        {content_type: 'text', title: 'Heavy Meal', payload: 'ORDER_HEAVY'},
        {content_type: 'text', title: 'Light Diet', payload: 'ORDER_LIGHT'},
      ]
    }
  end

  text.map do |t|
    postback.reply(text: t)
  end

  postback.reply(options) if options.present?
end
