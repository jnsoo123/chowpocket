class AddBuildingIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :building, foreign_key: true
  end
end
