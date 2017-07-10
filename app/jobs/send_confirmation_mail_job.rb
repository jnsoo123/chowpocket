class SendConfirmationMailJob < ApplicationJob
  queue_as :default 

  def perform
    Order.pending_today.map(&:user).uniq.each do |user|
      OrderMailer.order_confirmed(user).deliver
    end
    Order.pending_today.update_all(status: OrderStatuses::CONFIRMED)
  end
end
