class LineItem < ApplicationRecord
  belongs_to :menu
  belongs_to :cart

  def discount
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?

    clusters = Cluster.includes(:menu_clusters, :menu).
      where(date_created: date).
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
