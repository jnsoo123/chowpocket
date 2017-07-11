class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart)

    if @order.save
      set_menu_clusters
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
    object = Cluster.where(date_created: Date.today).where('menu_clusters_count < 3').first_or_create do |cluster_object|
      cluster_object.date_created = Date.today
    end
    object
  end

  def set_menu_clusters
    transaction do
      @order.cart.line_items.each do |item|
        MenuCluster.create do |menu_cluster|
          menu_cluster.order = @order
          menu_cluster.menu = item.menu
          menu_cluster.cluster
          menu_cluster.quantity = item.quantity
        end
      end
    end
  end
end
