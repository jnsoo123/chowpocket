class BuildingsController < ApplicationController
  skip_before_action  :authenticate_user!

  def index
    @menus = BuildingMenusFacade.new(@clusters).menus
  end
end
