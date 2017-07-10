class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart, cluster: cluster)

    if @order.save
      flash[:notice] = 'Your order has been made. Wait for an email for confirmation.'
      redirect_to root_path
    end
  end

  def index
    @orders = Order.includes(cart: {line_items: :menu}).where(carts: { user: current_user })
  end

  def destroy
    @order = current_user.orders.find(params[:id])
    @order.destroy
    redirect_to orders_path, notice: 'Your order has been cancelled.'
  end

  private
  def cluster
    object = Cluster.where(date_created: Date.today).where('orders_count < 3').first_or_create do |cluster_object|
      cluster_object.date_created = Date.today
    end
    object
  end
end
