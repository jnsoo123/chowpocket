class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_clusters
  before_action :set_cart
  before_action :configure_permitted_params, if: :devise_controller?
  before_action :authenticate_user!
  before_action :check_if_user_has_phone_number

  layout :layout_of_resource

  include OrdersHelper

  def after_sign_in_path_for(resource)
    buildings_path
  end

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
          price:    (item.menu.price - (item.menu.price * (get_discount(item.menu)) / 100.0 )).to_f, 
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :building_id, :floor, :phone_number, :company_name])
  end

  def check_if_user_has_phone_number
    if user_signed_in?
      if current_user.incomplete_credentials?
        flash[:error] = 'Please update your all your account details so that we can notify you to what ever happens. <a class="alert-link" href="/profiles">Update here</a>'
      end
    end 
  end

  def get_discount(menu)
    @clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:discount].to_f rescue 0
  end

  def set_clusters
    @clusters = Cluster.includes(:menu_clusters).where(date_created: get_date_cycle).order(id: :asc).collect do |cluster|
      {
        menu_id: cluster.menu.id,
        discount: cluster.discount,
        count: cluster.menu_clusters.sum('quantity')
      }
    end
  end
end
