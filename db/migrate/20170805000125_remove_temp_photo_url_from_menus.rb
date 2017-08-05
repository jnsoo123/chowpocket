class RemoveTempPhotoUrlFromMenus < ActiveRecord::Migration[5.1]
  def change
    remove_column :menus, :temp_photo_url, :text
  end
end
