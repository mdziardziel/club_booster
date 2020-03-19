FactoryBot.define do
  factory :club do
    sequence :name do |n|
      "Lech Poznań U#{n}"
    end

    owner_id { create(:user).id }
  end
end