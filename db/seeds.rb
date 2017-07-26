puts 'Creating admin user...'
if Rails.env.development?
  User.create!(
    email:                  'admin@example.com', 
    password:               'password', 
    password_confirmation:  'password', 
    role:                   'admin', 
    name:                   'Admin', 
    deleted_at:             nil
  )
else
  User.create(
    email:                  ENV['ADMIN_EMAIL'], 
    password:               ENV['ADMIN_PASSWORD'], 
    password_confirmation:  ENV['ADMIN_PASSWORD'], 
    role:                   'admin', 
    name:                   'Admin', 
    deleted_at:             nil
  )
end

if Rails.env.development?
  puts 'Creating menus...'
  foods = [
    'Braised Leeks with Mozzarella & a Fried Egg',
    'Lamb Salad with Fregola',
    'Smoked Pork Jowl with Pickles',
    'Scallop Sashimi with Meyer Lemon Confit',
    'Vegan Charcuterie',
    'Pappardelle with Sea Urchin and Cauliflower'
  ]

  14.times do |iteration|
    iterator = (iteration % 5) + 1  
    File.open(Rails.root.join("app/assets/images/food#{iterator}.jpg")) do |file|
      schedule = IceCube::Schedule.new(now = Time.now) do |s|
        s.add_recurrence_rule IceCube::Rule.weekly(2).day(iterator)
      end

      Menu.create do |menu|
        menu.name         = "Silog ##{iteration + 1}"
        menu.price        = 52 * (iteration + 1) 
        menu.avatar       = file
        menu.description  = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'
        menu.schedule     = schedule.to_yaml
      end
    end
  end
end

puts 'Creating buildings...'
Building.create(name: 'Globe Valero')

puts "Total Users: #{User.count}"
puts "Total Menus: #{Menu.count}"
puts "Total Building: #{Building.count}"
