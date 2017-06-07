class BuildingsController < ApplicationController
  before_action :set_building, only: :show

  def index
  end

  def show
    @menus = Menu.all
  end

  private
  def set_building
    Building.find_by_name(params[:name])
  end
end
