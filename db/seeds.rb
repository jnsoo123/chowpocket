puts 'Creating admin user...'
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role: 'admin', name: 'Admin', deleted_at: nil)

puts 'Creating menus...'
6.times do |iteration|
  Menu.create(name: "Food#{iteration + 1}", price: 10*(iteration + 1), avatar: ActionController::Base.helpers.asset_path("food#{iteration+1}.jpg"))
end

puts "Total Users: #{User.count}"
puts "Total Menus: #{Menu.count}"
