require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'GET_STARTED_PAYLOAD'
  },
  persistent_menu: [
    locale: 'default',
    composer_input_disabled: false,
    call_to_actions: [
      {
        title: 'Visit Our Website',
        type: 'web_url',
        url: 'http://www.chowpocket.com',
        webview_height_ratio: 'full'
      },
      {
        title: 'Register Now',
        type: 'web_url',
        url: 'http://www.chowpocket.com/users/sign_up',
        webview_height_ratio: 'full'
      },
      {
        title: 'Foods for today',
        type: 'web_url',
        url: 'http://www.chowpocket.com/buildings/1',
        webview_height_ratio: 'full'
      }
    ]
  ]
}, access_token: ENV['ACCESS_TOKEN'])

Bot.on :postback do |postback|
  puts postback.as_json

  text  = []
  options = {}
  fb_id = postback.sender['id']

  case postback.payload
  when 'GET_STARTED_PAYLOAD'
    text.push 'Hello there. You can inquire here.'
    options[:attachment] = {
      type: 'template',
      payload: {
        template_type: 'button',
        text: 'or you can choose options here',
        buttons: [
          {
            type: 'web_url',
            url: 'http://www.chowpocket.com',
            title: 'Visit Our Website'
          },
          {
            type: 'web_url',
            url: 'http://www.chowpocket.com/users/sign_up',
            title: 'Register Now'
          },
          {
            type: 'web_url',
            url: 'http://www.chowpocket.com/buildings/1',
            title: 'Foods for Today'
          }
        ]
      }
    }
  end

  text.map do |t|
    postback.reply(text: t)
  end

  postback.reply(options)
end
