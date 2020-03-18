FactoryBot.define do
  factory :club do
    sequence :name do |n|
      "Lech Poznań U#{n}"
    end
  end
end