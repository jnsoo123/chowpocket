class BuildingsController < ApplicationController
  before_action :set_building, only: :show
  skip_before_action :authenticate_user!

  def index
  end

  def show
    @menus = []
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1

    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?

    Menu.all.each do |menu|
      if date.send("#{menu.schedule.downcase}?")
        hash = { 
          id:             menu.id,
          name:           menu.name, 
          description:    menu.description,
          original_price: menu.price,
          price:          (menu.price - (menu.price * (get_discount(menu)) / 100.0 )).to_f, 
          image:          menu.avatar_url,
          percent:        get_discount(menu),
          count:          (@clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:count].to_i rescue 0)
        }
        @menus.push hash
      end
    end
  end

  private
  def set_building
    @building = Building.find(params[:id])
  end
end
