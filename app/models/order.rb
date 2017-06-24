class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  belongs_to :cart
  delegate :user, to: :cart

  after_create do
    cart.update is_ordered: true
  end

  def status
    if deleted? 
      'Cancelled'
    else
      is_delivered? ? 'Delivered' : 'Pending'
    end
  end

  def label
    case status
    when 'Cancelled'
      'label-danger'
    when 'Delivered'
      'label-success'
    when 'Pending'
      'label-warning'
    end
  end
end
