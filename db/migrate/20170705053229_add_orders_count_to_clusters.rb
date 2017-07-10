class AddOrdersCountToClusters < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :orders_count, :integer
  end
end
