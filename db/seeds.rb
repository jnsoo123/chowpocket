# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Creating admin user...'
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role: 'admin', name: 'Admin')

puts 'Creating menus...'
foods = %w(Sisig Rice Friedchicken Hotdog Giniling Sinigang Liempo Porkchop Chopseuy)
foods.each do |food|
  Menu.create(name: food, price: 10*([1,2,3,4,5].sample))
end


puts "Total Users: #{User.count}"
puts "Total Menus: #{Menu.count}"
