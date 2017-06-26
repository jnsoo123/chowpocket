ActiveAdmin.register User do
  scope 'Active', :without_deleted, default: true
  scope 'Inactive', :only_deleted
  
  permit_params :name, :email, :role, :provider

  actions :all, except: [:new]

  index do
    selectable_column
    id_column
    column :name
    column :email
    actions
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :name
      f.input :email
      f.input :role
      f.input :provider
    end

    f.actions
  end
end
