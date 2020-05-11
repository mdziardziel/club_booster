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



des1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus euismod maximus rutrum. Donec est enim, gravida at magna nec, mollis rutrum dolor. Vivamus id quam eget lorem convallis dapibus vitae in tortor. Duis id imperdiet mauris. Donec ornare sit amet ligula ut aliquet. Integer mattis nibh sit amet tempor scelerisque. Donec et sollicitudin erat, in lobortis diam. Nam scelerisque nisi odio, vitae aliquet erat mollis quis. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nam maximus nec quam fringilla consequat. Donec vehicula, leo at aliquet congue, mi sem eleifend ex, quis interdum nulla lacus viverra sem. Pellentesque tristique justo vel vestibulum accumsan. Mauris ac tortor et lacus feugiat vehicula et ut velit. Fusce magna orci, sollicitudin at nunc in, porta dictum nunc. '
des2 = 'Nam blandit consequat turpis id ornare. Aliquam erat volutpat. Vivamus sollicitudin pharetra ipsum, ut porta purus pretium vitae. Morbi lobortis eros non ante consectetur tristique. Phasellus vitae dictum risus. Proin ipsum odio, mollis a urna ac, varius lobortis metus. Vivamus a enim at diam porttitor dapibus. Aenean fermentum bibendum quam, at eleifend mi commodo et. In in molestie sem, semper pulvinar nunc. Maecenas ultrices quam ut bibendum rhoncus. Vivamus commodo libero sed massa dapibus efficitur. Nunc tincidunt dignissim mi et tincidunt. Integer venenatis risus ut interdum mattis. Curabitur ante ex, pharetra ut viverra vitae, iaculis in purus. Ut id blandit tellus, ut accumsan metus. '


user3 = User.where(email: 'filled@user.pl').first_or_create!(password: 'test_user', 
                                                             name: 'Andrzej', 
                                                             surname: 'Duda', 
                                                             birth_date: 20.years.ago, 
                                                             personal_description: des1,
                                                             career_description: des2,
                                                             avatar_url: 'https://avatarfiles.alphacoders.com/218/thumb-218445.jpg')

club2 = Club.where(name: 'Warta Poznań U17').first_or_create!(owner_id: user3.id)
club3 = Club.where(name: 'Widzew Łódź U17').first_or_create!(owner_id: user2.id)

club2_user1 = Member.where(user_id: user1.id, club_id: club2.id).first_or_create!(roles: ['PLAYER'])
club2_user2 = Member.where(user_id: user2.id, club_id: club2.id).first_or_create!(roles: ['PLAYER'])
club2_user3 = Member.where(user_id: user3.id, club_id: club2.id).first_or_create!


ev1 = Event.where(name: 'training1', club_id: club2.id).first_or_create!(start_date: 3.days.ago, symbol: 'T', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'training2', club_id: club2.id).first_or_create!(start_date: 3.days.ago, end_date: 2.days.ago, symbol: 'T', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'training3', club_id: club2.id).first_or_create!(start_date: 4.days.ago, end_date: 3.days.ago, symbol: 'T', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'training4', club_id: club2.id).first_or_create!(start_date: 5.days.ago, end_date: 4.days.ago, symbol: 'T', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'Match1', club_id: club2.id).first_or_create!(start_date: 3.days.ago, symbol: 'M', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'Match2', club_id: club2.id).first_or_create!(start_date: 4.days.ago, symbol: 'M', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'Match3', club_id: club2.id).first_or_create!(start_date: 5.days.ago, symbol: 'M', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })
ev1 = Event.where(name: 'Match4', club_id: club2.id).first_or_create!(start_date: 6.days.ago, symbol: 'M', participants: { club2_user3.id.to_s => true, club2_user2.id.to_s => nil, club2_user1.id.to_s => false })

Member.where(user_id: user3.id, club_id: club3.id).first_or_create!(roles: ['PLAYER'], approved: true)

puts 'seeds end'