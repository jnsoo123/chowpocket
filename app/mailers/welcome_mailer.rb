class WelcomeMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_mailer(user)
    @user = user
    mail(
      to: @user.email,
      subject: 'Welcome to Chowpocket',
      template_path: 'welcome_mailer',
      template_name: 'welcome_mailer'
    )
  end
end
