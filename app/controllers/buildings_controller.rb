class BuildingsController < ApplicationController
  before_action :set_building, only: :show
  skip_before_action :authenticate_user!

  def index
  end

  def show
    menu_order_count = Order.joins(cart: :line_items).group('line_items.menu_id').count
    @menus = Menu.all.collect do |menu|
      { 
        id:           menu.id,
        name:         menu.name, 
        description:  menu.description,
        price:        menu.price, 
        count:        menu_order_count[menu.id] || 0,
        image:        menu.avatar.url
      }
    end
  end

  private
  def set_building
    @building = Building.find_by_name(params[:name])
  end
end
