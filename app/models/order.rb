class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  belongs_to :cart
  delegate :user, to: :cart
  has_many :menu_clusters

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
  end

  after_destroy do
    destroy_menu_clusters
    self.update status: 'cancelled'
  end

  def self.today
    date_option = if DateTime.now.change({hour: 19}) > DateTime.now
                    { created_at: (DateTime.now - 1.day).change({ hour: 19 })..DateTime.now.change({ hour: 19 }) }
                  else
                    { created_at: DateTime.now.change({ hour: 19 })..(DateTime.now + 1.day).change({ hour: 19 }) }
                  end

    where(date_option)
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
      'label-default'
    when 'Waiting for confirmation'
      'label-warning'
    end
  end

  private
  def destroy_menu_clusters
    self.menu_clusters.destroy_all
  end

  def check_pending_orders
    if Order.pending.today.sum('quantity') > 5
      deliver_emails
    end
  end

  def deliver_emails
    SendConfirmationMailJob.perform_later
  end
end
