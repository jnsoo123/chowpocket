class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_cart

  def authenticate_user!
    redirect_to new_user_session_path unless current_user.is_admin? 
  end

  def set_cart
    @cart = if current_user.cart
              current_user.cart
            else
              Cart.create user: current_user
            end
  end
end
