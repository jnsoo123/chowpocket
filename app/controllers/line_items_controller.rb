class LineItemsController < ApplicationController
  def create
    menu = Menu.find(params[:id])
    line_item = @cart.add_menu menu.id
    line_item.save

    line_items = @cart.reload.line_items.includes(:menu).collect do |item|
      {
        menu: item.menu.name,
        quantity: item.quantity,
        price: item.menu.price
      } 
    end
    render json: { items: line_items, total_price: @cart.total_price }
  end
end
