FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
