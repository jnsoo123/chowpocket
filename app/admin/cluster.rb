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
end
