class MenuCluster < ApplicationRecord
  belongs_to :menu
  belongs_to :order
  belongs_to :cluster

  after_create do
    update_cluster_discount
  end

  after_destroy do
    update_cluster_discount
  end

  after_update do
    update_cluster_discount
  end

  private
  def update_cluster_discount
    case cluster.menu_clusters.sum('quantity')
    when 15..19
      set_discount = 10
    when 20..29
      set_discount = 20
    when 30..Float::INFINITY
      set_discount = 30
    else
      set_discount = nil
    end
    
    cluster.update discount: set_discount
  end
end
