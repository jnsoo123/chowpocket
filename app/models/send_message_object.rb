class SendMessageObject
  attr_reader :user, :name, :menu, :quantity, :building, :number

  def initialize(menu_cluster)
    @user     = menu_cluster.order.user
    @name     = menu_cluster.order.user.name
    @menu     = menu_cluster.menu
    @quantity = menu_cluster.quantity
    @building = menu_cluster.order.user.building.name
    @number   = menu_cluster.order.user.phone_number
  end
end
