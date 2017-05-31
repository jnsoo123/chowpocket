require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: ENV['ACCESS_TOKEN']
)

Bot.on :message do |msg|
  puts "@@@@@@@@@@@@@@@ #{msg.inspect}"
  if msg.quick_reply == 'MENU'
    msg.reply(
      text: 'Choose from listed menu',
      quick_replies: Menu.all.map do |menu|
        {
          context_type: 'text', 
          title: "#{menu.name} - #{menu.price}",
          payload: "#{menu.id}"
        }
      end
    )
  else
    msg.reply(
      text: 'We are almost ready to launch! Enter your details below to be one of the first ones in! Sign Up Now!',
      quick_replies: [
        {
          content_type: 'text',
          title: 'Menu',
          payload: 'MENU'
        },
        {
          content_type: 'text',
          title: 'Sign Up',
          payload: 'SIGN UP'
        }
      ]
    )
  end
end
