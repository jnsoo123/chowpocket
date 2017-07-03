class RemoveIsDeliveredFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :is_delivered, :boolean
  end
end
