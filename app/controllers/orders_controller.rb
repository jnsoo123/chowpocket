class OrdersController < ApplicationController
  def create
    @order = Order.new(cart: @cart)
    if @order.save
      flash[:notice] = 'Your order has been made. Wait for an email for confirmation.'
      redirect_to root_path
    end
  end

  def index
    @orders = current_user.orders
  end

  def show
  end
  
  def destroy
  end
end
