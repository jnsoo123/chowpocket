class AddUnionbankCodeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unionbank_code, :text
  end
end
