ActiveAdmin.register Order do
  index do
    selectable_column
    column :id
    column 'User' do |order|
      link_to order.cart.user.email, admin_user_path(order.cart.user)
    end
    column :is_delivered
    column 'Deleted/ Cancelled' do |order|
      order.deleted? ? status_tag('Yes', :ok) : status_tag('No') 
    end
    column :created_at
    column :updated_at

    column :actions do |object|
      div class: 'table_actions' do
        raw( %(#{link_to "View", [:admin, object], class: 'view_link member_link'} 
            #{link_to "Edit", [:admin, object], class: 'edit_link member_link'} 
            #{(link_to"Delete", [:admin, object], class: 'delete_link member_link', method: :delete) if not object.deleted? }) )
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :cart_id
      row 'User' do |order|
        link_to order.cart.user.email, admin_user_path(order.cart.user)
      end
      row 'Deleted/ Cancelled' do |order|
        order.deleted? ? status_tag('Yes', :ok) : status_tag('No') 
      end
      row :is_delivered
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
              td number_to_currency(order.cart.total_discounted_price, unit: 'P')
            end
          end
        end
      end
    end
  end
end
