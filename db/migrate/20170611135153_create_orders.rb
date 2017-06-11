class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :cart, foreign_key: true
      t.boolean :is_delivered, default: false

      t.timestamps
    end
  end
end
