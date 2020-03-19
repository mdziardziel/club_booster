FactoryBot.define do
  factory :event do
    sequence :name do |n|
      "Lech Poznań U#{n} - Amica Wronki U#{n}"
    end
    start_time { 2.days.from_now.to_i }
    club
  end
end