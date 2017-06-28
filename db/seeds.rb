puts 'Creating admin user...'
User.create(
  email:                  'admin@example.com', 
  password:               'password', 
  password_confirmation:  'password', 
  role:                   'admin', 
  name:                   'Admin', 
  deleted_at:             nil
)

puts 'Creating menus...'
foods = [
  'Braised Leeks with Mozzarella & a Fried Egg',
  'Lamb Salad with Fregola',
  'Smoked Pork Jowl with Pickles',
  'Scallop Sashimi with Meyer Lemon Confit',
  'Vegan Charcuterie',
  'Pappardelle with Sea Urchin and Cauliflower'
]

6.times do |iteration|
  File.open(Rails.root.join("app/assets/images/food#{iteration + 1}.jpg")) do |file|
    Menu.create do |menu|
      menu.name         = foods[iteration]
      menu.price        = 10 * (iteration + 1) 
      menu.avatar       = file
      menu.description  = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
    end
  end
end

puts "Total Users: #{User.count}"
puts "Total Menus: #{Menu.count}"
