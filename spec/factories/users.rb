FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }

    trait :admin do
      email { "admin@example.com" }
      admin { true }
    end

    trait :confirmed do
      confirmed_at { Time.current }
    end

    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
