FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    price { 1 }
    stock { 1 }
    active { false }
  end
end
