class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_cart
  before_action :configure_permitted_params, if: :devise_controller?
  before_action :authenticate_user!
  before_action :mark_cancelled_all_pending_orders_yesterday
  before_action :check_cluster_discount_availability

  layout :layout_of_resource

  def authenticate_admin!
    redirect_to root_path unless current_user.is_admin? 
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

  def mark_cancelled_all_pending_orders_yesterday
    Order.transaction do
      Order.pending.not_today.destroy_all
    end
  end

  def check_cluster_discount_availability
      
  end
end
