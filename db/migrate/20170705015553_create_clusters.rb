class CreateClusters < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.integer :discount

      t.timestamps
    end
  end
end
