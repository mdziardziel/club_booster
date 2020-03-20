FactoryBot.define do
  factory :member do
    roles { ['PLAYER'] }
    approved { true }
    user
    club
  end
end