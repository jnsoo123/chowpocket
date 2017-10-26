class AddTempPhotoUrlToMenus < ActiveRecord::Migration[5.1]
  def change
    add_column :menus, :temp_photo_url, :text
  end
end
