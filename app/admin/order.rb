ActiveAdmin.register Order do
  member_action :confirm_order, method: :put do
    resource.update status: 'confirmed'
    redirect_to admin_orders_path, notice: "Order ##{resource.id} Confirmed"
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
            #{link_to "Edit", [:admin, object], class: 'edit_link member_link'} 
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
      table_for order.cart.line_items.includes(:menu) do
        column :menu
        column :quantity
        column 'Price' do |item|
          number_to_currency(item.quantity * item.menu.price, unit: 'P')
        end
        column 'Discounted?' do |item|
          item.discount > 0 ? status_tag('Yes', :ok) : status_tag('No')
        end
        column 'Discounted Price' do |item|
          number_to_currency(item.discounted_price, unit: 'P')
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
              td number_to_currency(order.cart.total_price, unit: 'P')
            end
          end
        end
      end
    end
  end
end
