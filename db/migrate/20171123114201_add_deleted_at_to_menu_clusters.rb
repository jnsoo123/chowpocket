class AddDeletedAtToMenuClusters < ActiveRecord::Migration[5.1]
  def change
    add_column :menu_clusters, :deleted_at, :datetime
    add_index :menu_clusters, :deleted_at

    add_column :clusters, :deleted_at, :datetime
    add_index :clusters, :deleted_at
  end
end
