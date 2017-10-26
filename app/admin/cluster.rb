ActiveAdmin.register Cluster do
  actions :index, :show
  
  index do
    selectable_column
    id_column
    column :menu
    column 'Quantity' do |cluster|
      cluster.menu_clusters.sum('quantity')
    end
    column :discount
    actions
  end

  show do
    attributes_table do
      row :id
      row :menu
      row :discount
      row :date_created
    end

    panel 'Order Item List' do
      table_for cluster.menu_clusters.includes(:order) do
        column :order
        column :quantity
      end
    end
  end

  controller do
    skip_before_action :set_clusters
  end
end
