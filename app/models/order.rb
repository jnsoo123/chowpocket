class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  belongs_to :cart
  delegate :user, to: :cart

  scope :confirmed_quantity, -> { confirmed_today.sum('quantity') }
  scope :pending,   -> {includes(cart: :line_items).without_deleted.where(status: OrderStatuses::PENDING)} do
    def date_option
      if DateTime.now.change({hour: 19}) > DateTime.now
        { created_at: (DateTime.now - 1.day).change({ hour: 19 })..DateTime.now.change({ hour: 19 }) }
      else
        { created_at: DateTime.now.change({ hour: 19 })..(DateTime.now + 1.day).change({ hour: 19 }) }
      end
    end

    def today
      where(date_option)
    end

    def not_today
      where.not(date_option)
    end
  end
  scope :confirmed, -> {includes(cart: :line_items).without_deleted.where(status: OrderStatuses::CONFIRMED)} do
    def date_option
      if DateTime.now.change({hour: 19}) > DateTime.now
        { created_at: (DateTime.now - 1.day).change({ hour: 19 })..DateTime.now.change({ hour: 19 }) }
      else
        { created_at: DateTime.now.change({ hour: 19 })..(DateTime.now + 1.day).change({ hour: 19 }) }
      end
    end

    def today
      where(date_option)
    end

    def not_today
      where.not(date_option)
    end
  end
  
  after_create do
    cart.update is_ordered: true
    check_pending_orders
    check_discount_availability
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

  private
  def check_pending_orders
    if Order.pending.today.sum('quantity') > 10
      deliver_emails
    end
  end

  def deliver_emails
    SendConfirmationMailJob.perform_later
  end

  def check_discount_availability
#    case Order.confirmed_today_quantity
#    when 10..19
#    when 20..29
#    when 30..Float::INFINITY
#    end
  end
end
