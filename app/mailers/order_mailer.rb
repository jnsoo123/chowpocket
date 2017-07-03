class OrderMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def order_confirmed(user)
    @user = user
    @order_date = @user.orders.confirmed.last.created_at
    mail(to: @user.email, subject: 'Order Confirmed!')
  end
end
