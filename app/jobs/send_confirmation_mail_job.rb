class SendConfirmationMailJob < ApplicationJob
  queue_as :default 

  def perform
    sleep 3
    orders = Order.pending.today
    orders.map(&:user).uniq.each do |user|
      OrderMailer.order_confirmed(user).deliver
    end
    orders.update_all(status: OrderStatuses::WAITING)
    orders.collect do |order|
      order.send_notifications(OrderStatuses::WAITING)
    end
  end
end
