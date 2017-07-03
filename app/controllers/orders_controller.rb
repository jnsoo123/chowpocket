class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart)

    if @order.save
      check_pending_orders
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
  def check_pending_orders
    orders = Order.pending
    if orders.joins(cart: :line_items).sum('quantity') > 10
      orders.update_all(status: OrderStatuses::CONFIRMED)
    end
  end
end
