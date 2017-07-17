class BuildingsController < ApplicationController
  before_action :set_building, only: :show
  skip_before_action :authenticate_user!

  def index
  end

  def show
    menu_order_count = Order.today.joins(cart: :line_items).
      group('line_items.menu_id').
      sum('quantity')

    @menus = Menu.all.collect do |menu|
      { 
        id:           menu.id,
        name:         menu.name, 
        description:  menu.description,
        price:        menu.price, 
        count:        menu_order_count[menu.id] || 0,
        image:        menu.avatar.url,
        percent:      get_discount_percentage(menu_order_count[menu.id])
      }
    end
  end

  private
  def set_building
    @building = Building.find_by_name(params[:name])
  end

  def get_discount_percentage(count)
    case count
    when 30..39
      10
    when 40..49
      20
    when 50..Float::INFINITY
      30
    else
      0
    end
  end
end
