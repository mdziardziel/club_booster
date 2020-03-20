FactoryBot.define do
  factory :club do
    sequence :name do |n|
      "Lech Poznań U#{n}"
    end
    sequence :token do |n|
      "jdgnerngieafeofinsaogergundvoa#{n}"
    end

    owner_id { create(:user).id }
  end
end