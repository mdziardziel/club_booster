FactoryBot.define do
  factory :group do
    sequence :name do |n|
      "Defenders #{n}"
    end
    club
  end
end