class BuildingsController < ApplicationController
  before_action :set_building, only: :show
  before_action :set_clusters, only: :show
  skip_before_action :authenticate_user!

  def index
  end

  def show
    @menus = Menu.all.collect do |menu|
      { 
        id:           menu.id,
        name:         menu.name, 
        description:  menu.description,
        price:        (menu.price - (menu.price * (get_discount(menu)) / 100.0 )).to_f, 
        image:        menu.avatar.url,
        percent:      get_discount(menu),
        count:        (@clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:count].to_i rescue 0)
      }
    end
  end

  private
  def set_building
    @building = Building.find_by_name(params[:name])
  end

  def get_discount(menu)
    @clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:discount].to_f rescue 0
  end

  def set_clusters
    @clusters = Cluster.includes(:menu_clusters).where(date_created: Date.today).order(id: :asc).collect do |cluster|
      {
        menu_id: cluster.menu.id,
        discount: cluster.discount,
        count: cluster.menu_clusters.sum('quantity')
      }
    end
  end
end
