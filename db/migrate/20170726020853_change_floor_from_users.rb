class ChangeFloorFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :floor, :string
  end
end
