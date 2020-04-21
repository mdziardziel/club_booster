FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user#{n}@email.com"
    end
    password { 'iojdnasosdiasd889y' }
    name { 'Andrzej' }
    surname { 'Nowak' }
    birth_date { 10.years.ago }
    personal_description { 'asdad' }
    career_description { 'asdad' }
    avatar_url { nil }
  end
end