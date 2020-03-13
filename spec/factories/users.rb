FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@email.com"
    end
    password { 'iojdnasosdiasd889y' }
  end
end