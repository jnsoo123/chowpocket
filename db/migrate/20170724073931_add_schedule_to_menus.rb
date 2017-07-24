class AddScheduleToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :schedule, :string
  end
end
