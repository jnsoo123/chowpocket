class RemoveColumnsFromCluster < ActiveRecord::Migration[5.1]
  def change
    remove_column :clusters, :orders_count, :integer
    add_column :clusters, :menu_clusters_count, :integer
  end
end
