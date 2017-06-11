class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  def add_menu(menu)
    current_item = line_items.find_by_menu_id(menu)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build menu_id: menu, quantity: 1
    end
    current_item
  end 
end
