class RemoveClusterIdFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_reference :orders, :cluster, foreign_key: true
  end
end
