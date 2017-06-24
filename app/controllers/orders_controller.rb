class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart)
    if @order.save
      flash[:notice] = 'Your order has been made. Wait for an email for confirmation.'
      redirect_to root_path
    end
  end

  def index
    @orders = Order.includes(cart: {line_items: :menu}).where(carts: { user: current_user })
  end

  def show
  end
  
  def destroy
  end
end
