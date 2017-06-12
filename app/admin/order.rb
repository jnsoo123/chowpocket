ActiveAdmin.register Order do
  index do
    selectable_column
    column :id
    column 'User' do |order|
      link_to order.cart.user.email, admin_user_path(order.cart.user)
    end
    column :is_delivered
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :cart_id
      row 'User' do |order|
        link_to order.cart.user.email, admin_user_path(order.cart.user)
      end
      row :is_delivered
      row :created_at
      row :updated_at
    end

    panel 'Order List' do
      attributes_table_for order do
        row 'Menu Items' do
          order.cart.line_items.map do |item|
            link_to "#{item.menu.name} x #{item.quantity} = P#{item.menu.price * item.quantity}", admin_menu_path(item.menu)
          end.join('<br>').html_safe
        end
        row 'Total Price' do
          order.cart.total_price
        end
      end
    end
  end
end
