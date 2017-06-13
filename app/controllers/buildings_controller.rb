class BuildingsController < ApplicationController
  before_action :set_building, only: :show

  def index
  end

  def show
    menu_order_count = Order.joins(cart: :line_items).group('line_items.menu_id').count
    @menus = Menu.all.collect do |menu|
      { 
        name: menu.name, 
        price: menu.price, 
        count: menu_order_count[menu.id] || 0
      }
    end
  end

  private
  def set_building
    Building.find_by_name(params[:name])
  end
end
