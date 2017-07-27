class LineItem < ApplicationRecord
  belongs_to :menu
  belongs_to :cart

  def discount
    Cluster.joins(:menu_clusters).where(menu_clusters: {menu: self.menu, order: self.cart.order}).uniq.last.discount rescue 0
  end

  def discounted_price
    (self.menu.price - (self.menu.price * self.discount / 100.0)).to_f * quantity
  end
end
