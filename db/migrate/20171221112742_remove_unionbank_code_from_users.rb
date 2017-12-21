class RemoveUnionbankCodeFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :unionbank_code, :text
  end
end
