require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |msg|
  puts msg.inspect

  fb_id = msg.sender['id']

  @user = ChatbotUser.where(facebook_id: fb_id).first_or_create do |user|
    user.facebook_id = fb_id
    user.state = 'REGISTRATION_1'
  end

  case @user.state
  when 'REGISTRATION_1'
    msg.reply(
      text: 'We are almost ready to launch! Enter your details below to be one of the first ones in! Sign up now! Please enter your name.',
    )
    @user.update state: 'REGISTRATION_2'
  when 'REGISTRATION_2'
    msg.reply(
      attachment: {
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
    )
    @user.update name: msg.text
  when 'REGISTRATION_3'
    msg.reply(
      attachment: {
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
    )
    @user.update contact_number: msg.text
  end
end

Bot.on :postback do |postback|
  fb_id = postback.sender['id']
  @user = ChatbotUser.where(facebook_id: fb_id).first

  case postback.payload
  when 'REGISTRATION_2_YES'
    text = 'Please enter your contact info.'
    @user.update state: 'REGISTRATION_3'
  when 'REGISTRATION_2_NO'
    text = 'Please enter your name.'
  when 'REGISTRATION_3_YES'
    text = 'Congratulations! You have successfully registered on our store.'
    @user.update state: 'REGISTRATION_DONE'
  when 'REGISTRATION_3_NO'
    text = 'Please enter your contact info.'
  end

  postback.reply(text: text)
end
