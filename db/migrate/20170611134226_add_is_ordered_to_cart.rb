class AddIsOrderedToCart < ActiveRecord::Migration[5.1]
  def change
    add_column :carts, :is_ordered, :boolean, default: false
  end
end
