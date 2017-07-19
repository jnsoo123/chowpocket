class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart)

    if @order.save!
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
  def create_cluster(menu_id)
    Cluster.create(menu_id: menu_id, date_created: Date.today)
  end

  def set_cluster(menu_id)
    cluster = Cluster.where(menu_id: menu_id, date_created: Date.today).last
    begin
      if cluster.menu_clusters.sum('quantity') > 50
        cluster = create_cluster(menu_id)
      end
    rescue
      cluster = create_cluster(menu_id)
    end
    cluster
  end

  def set_menu_clusters
    @order.cart.line_items.each do |item|
      MenuCluster.create! do |menu_cluster|
        menu_cluster.order = @order
        menu_cluster.menu = item.menu
        menu_cluster.cluster = set_cluster(item.menu.id)
        menu_cluster.quantity = item.quantity
      end
    end
  end
end
