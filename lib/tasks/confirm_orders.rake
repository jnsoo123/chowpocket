namespace :orders do
  desc 'Confirms Order'
  task confirm: :environment do
    puts 'Confirming Orders' 
    puts '----------------'

    Order.confirm_orders
  end
end
