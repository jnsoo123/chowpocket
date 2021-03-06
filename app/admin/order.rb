ActiveAdmin.register Order do
  scope 'Current Orders', default: true do |scope|
    scope.ransack({created_at_gt: get_datetime_cycle, created_at_lt: get_datetime_cycle_next_day}).result
  end
  scope('All') {|scope| scope.all }

  actions :index, :show, :edit, :destroy, :update

  permit_params :status

  member_action :confirm_order, method: :put do
    resource.update status: 'confirmed'
    redirect_to admin_orders_path, notice: "Order ##{resource.id} Confirmed"
  end

  form do |f|
    f.inputs 'Order Details' do
      f.input :status, as: :select, collection: OrderStatuses::ALL
    end

    f.actions
  end

  index do
    selectable_column
    column :id
    column 'User' do |order|
      link_to order.cart.user.email, admin_user_path(order.cart.user)
    end
    column :status do |order|
      status_tag(order.state, class: "#{order.label}")
    end
    column 'Contact #' do |order|
      order.user.phone_number || '--'
    end
    column 'Nth order' do |order|
      order.user.orders.where(status: OrderStatuses::CONFIRMED).count.ordinalize
    end
    column :actions do |object|
      div class: 'table_actions' do
        raw( %(
            #{link_to "View", [:admin, object], class: 'view_link member_link'} 
            #{link_to "Edit", edit_admin_order_path(object), class: 'edit_link member_link'} 
            #{(link_to 'Confirm Order', confirm_order_admin_order_path(object), class: 'member_link', method: :put, data: { confirm: 'Sure you want to confirm this order?' }) if not object.deleted? || object.state.downcase == OrderStatuses::CONFIRMED}
            #{(link_to "Cancel Order", [:admin, object], class: 'delete_link member_link', method: :delete, data: { confirm: 'Sure you want to cancel this order?' }) if not object.deleted? || object.state.downcase == OrderStatuses::CONFIRMED }
            ) )
      end
    end
  end

  sidebar 'User Details', only: :show do
    attributes_table_for resource.user do
      row :name
      row :email do |user|
        span link_to user.email, admin_user_path(user)
      end
      row 'Building' do |user|
        span user.building.name
      end
      row 'Company' do |user|
        span user.company_name
      end
      row :floor
    end
  end

  show do
    attributes_table do
      row :id
      row :status do
        status_tag(order.state, class: "#{order.label}")
      end 
      row :cart_id
      row 'Deleted/ Cancelled' do |order|
        order.deleted? ? status_tag('Yes', :ok) : status_tag('No') 
      end
      row :is_delivered
      row 'Nth order' do |order|
        order.user.orders.where(status: OrderStatuses::CONFIRMED).count.ordinalize
      end
      row :created_at
      row :updated_at
    end

    panel 'Order List' do
      clusters = Cluster.all
      table_for order.menu_clusters.includes(:cluster) do
        column :menu
        column :quantity
        column 'Price' do |mc|
          number_to_currency(mc.quantity * mc.menu.price, unit: 'P')
        end
        column 'Discounted?' do |mc|
          (mc.cluster.discount || 0) > 0 ? status_tag('Yes', :ok) : status_tag('No')
        end
        column 'Discounted Price' do |mc|
          number_to_currency(mc.discounted_price, unit: 'P')
        end
      end
      div class: 'panel_contents' do
        table do
          thead do
            tr do
              th
              th
              th
            end
          end
          tbody do
            tr do
              td 'Total Price'
              td
              td number_to_currency(order.total_price, unit: 'P')
            end
          end
        end
      end
    end
  end

  controller do
    def update
      if resource.status != OrderStatuses::CANCELLED
        resource.deleted_at = nil
      end
      update!
    end

    def destroy
      resource.status = OrderStatuses::CANCELLED
      destroy!(notice: 'Order has been cancelled') { admin_orders_path }
    end
  end

  csv column_names: true do
    column 'Order ID' do |order|
      order.id
    end
    column 'Name' do |order|
      order.cart.user.name
    end
    column 'User Email' do |order|
      order.cart.user.email
    end
    column 'Contact #' do |order|
      order.user.phone_number || '--'
    end
    column 'Building' do |order|
      order.cart.user.building.name rescue nil
    end
    column 'Company' do |order|
      order.cart.user.company_name rescue nil
    end
    column 'Floor' do |order|
      order.cart.user.floor rescue nil
    end
    column :state
    column 'Orders' do |order|
      order.menu_clusters.includes(:cluster).collect do |mc|
        "-- #{mc.menu.name} x #{mc.quantity} - #{number_to_currency(mc.discounted_price, unit: 'P')} - #{mc.cluster.discount || 0}% Off -- "
      end
    end
    column 'Total Price' do |order|
      number_to_currency(order.total_price, unit: 'P')
    end

  end
end
