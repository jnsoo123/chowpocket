class Cart < ApplicationRecord
  acts_as_paranoid without_default_scope: true

  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_one :order, dependent: :destroy

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
      total = 0.0
      if not item.discount.zero?
        price = item.menu.price - (item.menu.price * item.discount.to_f / 100)
        total += price * item.quantity
      else
        total += item.menu.price * item.quantity
      end
      total
    end.sum
  end
end
