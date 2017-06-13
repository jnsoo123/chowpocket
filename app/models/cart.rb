class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  scope :unordered, -> { where(is_ordered: false) }

  def add_menu(menu)
    current_item = line_items.find_by_menu_id(menu)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build menu_id: menu, quantity: 1
    end
    current_item
  end 

  def total_price
    price = line_items.map do |item|
      item.menu.price * item.quantity
    end.sum

    "P#{price}"
  end
end
