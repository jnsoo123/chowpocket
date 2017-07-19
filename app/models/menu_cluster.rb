class MenuCluster < ApplicationRecord
  belongs_to :menu
  belongs_to :order
  belongs_to :cluster

  after_create do
    case cluster.menu_clusters.sum('quantity')
    when 30..39
      set_discount = 10
    when 40..49
      set_discount = 20
    when 50..Float::INFINITY
      set_discount = 30
    end

    cluster.update discount: set_discount
  end
end
