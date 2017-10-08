class Order < ApplicationRecord
  acts_as_paranoid without_default_scope: true
  belongs_to :cart
  delegate :user, to: :cart
  has_many :menu_clusters

  validates_inclusion_of :status, in: OrderStatuses::ALL

  scope :confirmed_quantity, -> { confirmed_today.sum('quantity') }
  scope :pending,   -> {includes(cart: :line_items).without_deleted.where(status: OrderStatuses::PENDING)}
  scope :confirmed, -> {includes(cart: :line_items).without_deleted.where(status: OrderStatuses::CONFIRMED)}

  def self.today 
    date_option = ApplicationController.helpers.get_date_cycle_for_scopes
    ransack(date_option).result
  end

  def self.not_today 
    date_option = ApplicationController.helpers.get_date_cycle_for_scopes
    orders = ransack(date_option).result
    Order.where.not(id: orders.map(&:id))
  end

  after_create do
    cart.update is_ordered: true
    send_notifications(OrderStatuses::PENDING)
  end

  after_destroy do
    destroy_menu_clusters
  end

  def self.confirm_orders
    order_ids = []
    orders    = Order.includes(cart: :user).today.pending

    Order.transaction do
      orders.each do |order|
        order.update status: OrderStatuses::CONFIRMED
        order.send_notifications OrderStatuses::CONFIRMED
        order_ids.push order.id
      end
    end

    order_ids

    menu_clusters = MenuCluster.includes(:menu, order: {cart: {user: :building}}).where(order_id: order_ids)
    menu_clusters.each do |mc|
      send_message_object = SendMessageObject.new(mc) 
      api = SemaphoreApi.new(send_message_object)
      api.send_message unless send_message_object.user.is_admin?
    end
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

  def send_notifications(type)
    message = if type == OrderStatuses::WAITING
                "Your order has been made and is waiting for confirmation"
              elsif type == OrderStatuses::CONFIRMED 
                "Your order has been confirmed"
              elsif type == OrderStatuses::PENDING
                'Your order has been made and is pending'
              end

    Notification.create! do |notif|
      notif.user              = self.user
      notif.message           = message
      notif.notification_type = NotificationTypes::ORDER
      notif.status            = NotificationStatuses::UNREAD
    end
  end

  def total_price
    self.menu_clusters.includes(:cluster).map do |mc| 
      total = 0.0
      discount = mc.cluster.discount
      if not discount.nil?
        price = mc.menu.price - (mc.menu.price * discount.to_f / 100)
        total += price * mc.quantity
      else
        total += mc.menu.price * mc.quantity
      end
      total
    end.sum
  end

  private
  def get_date_cycle
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?
    date
  end

  def destroy_menu_clusters
    self.menu_clusters.destroy_all
  end

  def deliver_emails
    SendConfirmationMailJob.perform_later
  end
end
