class ChangeStatusFromOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :status, :string, default: 'pending'
  end
end
