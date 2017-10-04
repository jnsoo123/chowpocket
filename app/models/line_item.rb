class LineItem < ApplicationRecord
  include DateCycle

  belongs_to :menu
  belongs_to :cart

  def discount
    clusters = Cluster.includes(:menu_clusters, :menu).
      where(date_created: get_date_cycle).
      order(id: :asc).
      collect do |cluster|
        {
          menu_id: cluster.menu.id,
          discount: cluster.discount,
        }
      end

    clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:discount].to_f rescue 0
  end

  def discounted_price
    (self.menu.price - (self.menu.price * self.discount / 100.0)).to_f * quantity
  end
end
