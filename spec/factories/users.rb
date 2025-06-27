FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :admin do
      admin { true }
      name { nil }
    end
  end
end
