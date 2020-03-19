# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'seeds started'

user1 = User.where(email: 'test_user@user.pl').first_or_create!(password: 'test_user')
user2 = User.where(email: 'user@jwt.pl').first_or_create!(password: 'test_user')
puts "JWT: #{user2.generate_jwt}"

club1 = Club.where(name: 'Górnik Konin U19').first_or_create!(owner_id: user1.id)

# tests in seeds :p
club1.users
club1.members
user1.clubs
user1.members

puts 'seeds end'