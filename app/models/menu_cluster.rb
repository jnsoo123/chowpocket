class MenuCluster < ApplicationRecord
  acts_as_paranoid
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

  before_destroy do
    self.order.delete
  end

  def discounted_price
    discount = self.cluster.discount || 0
    (self.menu.price - (self.menu.price * discount / 100.0)).to_f * self.quantity
  end

  private
  def update_cluster_discount
    case cluster.menu_clusters.sum('quantity')
    when 10..19
      set_discount = 30
    when 20..24
      set_discount = 40
    when 25..Float::INFINITY
      set_discount = 50
    else
      set_discount = nil
    end
    
    cluster.update discount: set_discount
  end
end
