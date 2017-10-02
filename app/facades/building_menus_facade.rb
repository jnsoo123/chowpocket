class BuildingMenusFacade
  attr_reader :menus

  def initialize(clusters)
    @date     = set_date
    @clusters = clusters
    @menus    = fetch_menus
  end

  private
  def fetch_menus
    menus = []

    Menu.all.each do |menu|
      if @date.send("#{menu.schedule.downcase}?")
        hash = {
          id:             menu.id,
          name:           menu.name, 
          description:    menu.description,
          original_price: menu.price,
          price:          (menu.price - (menu.price * (get_discount(menu)) / 100.0 )).to_f, 
          image:          menu.avatar_url,
          percent:        get_discount(menu),
          count:          (@clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:count].to_i rescue 0)
        }
        menus.push hash
      end
    end

    menus
  end

  def set_date
    date = DateTime.now < DateTime.now.change({hour: 19}) ? Date.today : Date.today + 1
    date = date - 1.day if date.saturday?
    date = date - 2.day if date.sunday?
    date
  end

  def get_discount(menu)
    @clusters.select {|cluster| cluster[:menu_id] == menu.id}.last[:discount].to_f rescue 0
  end
end
