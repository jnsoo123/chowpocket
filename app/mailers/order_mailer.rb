class OrderMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def order_confirmed(user)
    @user = user
    @order_date = @user.orders.pending.last.created_at
    mail(
      to: @user.email, 
      subject: 'Order Confirmed!',
      template_path: 'order_mailer',
      template_name: 'order_confirmed'
    )
  end
end
