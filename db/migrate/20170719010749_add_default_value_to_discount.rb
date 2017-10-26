class AddDefaultValueToDiscount < ActiveRecord::Migration[5.1]
  def change
    change_column :clusters, :discount, :integer, default: 0
  end
end
