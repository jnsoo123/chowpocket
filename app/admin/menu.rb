ActiveAdmin.register Menu do
  permit_params :name, :price, :avatar, :description, :temp_photo_url, :schedule

  index do
    selectable_column
    id_column
    column :name
    column :price do |menu|
      "P#{menu.price}"
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :price
      row :description
      row :avatar do |menu|
        menu.avatar_url
      end
      row :schedule do |menu|
        ScheduleDays::DISPLAY_VALUE[menu.schedule]
      end
    end
  end

  form do |f|
    f.inputs 'Menu Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :schedule, as: :select, collection: ScheduleDays::ALL
      f.input :avatar, as: :file
    end
    f.actions
  end
end
