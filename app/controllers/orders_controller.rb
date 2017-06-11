class OrdersController < ApplicationController
  def create
    cart = current_user.current_cart
    @order = Order.new(cart: cart)
    if @order.save
      flash[:notice] = 'Your order has been made. Wait for an email for confirmation.'
      redirect_to root_path
    end
  end
end
