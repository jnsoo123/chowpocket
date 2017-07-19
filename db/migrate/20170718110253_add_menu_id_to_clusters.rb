class AddMenuIdToClusters < ActiveRecord::Migration[5.1]
  def change
    add_reference :clusters, :menu, foreign_key: true
  end
end
