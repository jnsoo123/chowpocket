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
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    Cluster.create(menu_id: menu_id, date_created: date)
  end

  def set_cluster(menu_id)
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?

    cluster = Cluster.where(menu_id: menu_id, date_created: date).last
    begin
      cluster_quantity = cluster.menu_clusters.sum('quantity')
      if cluster_quantity > 49
        cluster = create_cluster(menu_id)
      end
      create_cluster(menu_id) if cluster_quantity == 49
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
