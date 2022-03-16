FactoryBot.define do
  factory :user do
    username {Faker::Movies::LordOfTheRings.character}
    password {'password'}
  end
end