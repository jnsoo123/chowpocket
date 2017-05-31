require 'facebook/messenger'

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: ENV['ACCESS_TOKEN']
)

Bot.on :message do |msg|
  Bot.deliver({
    recipient: msg.sender,
    message: {
      text: msg.text
    }
  }, access_token: ENV['ACCESS_TOKEN'])
end
