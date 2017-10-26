class AddClusterIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :cluster, foreign_key: true
  end
end
