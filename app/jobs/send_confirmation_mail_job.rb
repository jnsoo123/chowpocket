class SendConfirmationMailJob < ApplicationJob
  queue_as :default 

  def perform
    Order.pending.today.map(&:user).uniq.each do |user|
      OrderMailer.order_confirmed(user).deliver
    end
    Order.pending.today.update_all(status: OrderStatuses::WAITING)
  end
end
