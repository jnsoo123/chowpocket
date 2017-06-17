class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_cart
  before_action :configure_permitted_params, if: :devise_controller?

  layout :layout_of_resource

  def authenticate_user!
    redirect_to new_user_session_path unless current_user.is_admin? 
  end

  def set_cart
    if user_signed_in?
      @cart = current_user.current_cart.presence || Cart.create(user: current_user)
      @line_items = @cart.line_items.includes(:menu).collect do |item|
        {
          id: item.id,
          menu: item.menu.name,
          quantity: item.quantity,
          price: item.menu.price
        } 
      end.to_json
    end
  end

  def layout_of_resource
    if devise_controller?
      'devise'
    else
      'application'
    end
  end

  private

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
