class CreateMenuClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :menu_clusters do |t|
      t.references :menu, foreign_key: true
      t.references :order, foreign_key: true
      t.references :cluster, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
