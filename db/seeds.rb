# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Deletes all records and resets the ID count

ActiveRecord::Base.connection.execute("TRUNCATE TABLE airports RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE flights RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE bookings RESTART IDENTITY CASCADE")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE passengers RESTART IDENTITY CASCADE")
# Scans the db/seeds/*.rb seed files and executes them in order of number.

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "Processing #{file.split('/').last}"
  require file
end
