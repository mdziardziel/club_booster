FactoryBot.define do
  factory :event do
    sequence :name do |n|
      "Lech Poznań U#{n} - Amica Wronki U#{n}"
    end
    start_date { 2.days.from_now }
    club
  end
end