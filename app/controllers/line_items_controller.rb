class LineItemsController < ApplicationController
  def create
    menu = Menu.find(params[:id])
    line_item = @cart.add_menu menu.id
    line_item.save

    render json: { items: line_items, total_price: @cart.total_price }
  end

  def update
    line_item = @cart.line_items.find(params[:id])    
    line_item.update line_items_params

    render json: { items: line_items, total_price: @cart.total_price } 
  end

  private
  def line_items_params
    params.require(:line_items).permit(:quantity)
  end

  def line_items
    @cart.reload.line_items.includes(:menu).collect do |item|
      {
        id: item.id,
        menu: item.menu.name,
        quantity: item.quantity,
        price: item.menu.price
      } 
    end
  end
end
