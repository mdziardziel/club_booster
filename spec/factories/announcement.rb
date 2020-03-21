FactoryBot.define do
  factory :announcement do
    sequence :content do |n|
      "Lorem ipsum #{n}"
    end
    club
  end
end