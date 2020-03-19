FactoryBot.define do
  factory :member do
    roles { ['PLAYER'] }
    user
    club
  end
end