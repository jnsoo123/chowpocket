class LineItemsController < ApplicationController
  def create
    menu = Menu.find(params[:id])
    line_item = @cart.add_menu menu.id
    line_item.save
  end
end
