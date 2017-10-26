class AddDateCreatedToClusters < ActiveRecord::Migration[5.1]
  def change
    add_column :clusters, :date_created, :date
  end
end
