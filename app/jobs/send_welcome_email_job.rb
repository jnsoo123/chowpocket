class SendWelcomeEmailJob < ApplicationJob
  queue_as :default

  def perform(user)
    WelcomeMailer.welcome_mailer(user).deliver
  end
end
