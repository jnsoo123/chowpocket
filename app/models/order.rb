class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :cart
  delegate :user, to: :cart

  scope :pending, ->    { without_deleted.where(status: OrderStatuses::PENDING) }
  scope :confirmed, ->  { without_deleted.where(status: OrderStatuses::CONFIRMED) }
  
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
