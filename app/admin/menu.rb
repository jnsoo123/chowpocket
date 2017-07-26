ActiveAdmin.register Menu do
  permit_params :name, :price, :avatar, :description

  index do
    selectable_column
    id_column
    column :name
    column :price do |menu|
      "P#{menu.price}"
    end
    actions
  end

  form do |f|
    f.inputs 'Menu Details' do
      f.input :name
      f.input :description
      f.input :price
      f.input :avatar, as: :file
    end
    f.actions
  end
end
