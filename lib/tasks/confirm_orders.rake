namespace :orders do
  desc 'Confirms Order'
  task confirm: :environment do
    puts 'Confirming Orders' 
    puts '----------------'

    order_ids = Order.confirm_orders

    if not order_ids.empty?
      print "Order IDs #{order_ids} confirmed"
    else
      print 'No orders can be confirmed'
    end
  end
end
