FactoryBot.define do
  factory :event do
    sequence :name do |n|
      "Lech Poznań U#{n} - Amica Wronki U#{n}"
    end
    start_date { 3.days.from_now.strftime('%FT%T') }
    end_date { 2.days.from_now.strftime('%FT%T') }
    symbol { Event::SYMBOLS.first }
    club
  end
end