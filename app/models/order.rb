class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :cart
  delegate :user, to: :cart

  scope :pending, ->    { without_deleted.where(status: OrderStatuses::PENDING).where('created_at < ?', DateTime.now.beginning_of_day) }
  scope :confirmed, ->  { without_deleted.where(status: OrderStatuses::CONFIRMED).where('created_at < ?', DateTime.now.beginning_of_day) }

  scope :pending_today, ->    { without_deleted.where(status: OrderStatuses::PENDING).where('created_at > ?', DateTime.now.beginning_of_day) }
  scope :confirmed_today, ->  { without_deleted.where(status: OrderStatuses::CONFIRMED).where('created_at > ?', DateTime.now.beginning_of_day) }
  
  after_create do
    cart.update is_ordered: true
  end

  def state
    if deleted? 
      'Cancelled'
    else
      status.capitalize
    end
  end

  def label
    case state
    when 'Confirmed'
      'label-info'
    when 'Cancelled'
      'label-danger'
    when 'Delivered'
      'label-success'
    when 'Pending'
      'label-warning'
    end
  end
end
