class RemoveMenuClustersCountFromClusters < ActiveRecord::Migration[5.1]
  def change
    remove_column :clusters, :menu_clusters_count, :integer
  end
end
