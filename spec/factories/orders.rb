FactoryBot.define do
  factory :order do
    user { nil }
    total_price { 1 }
    status { "MyString" }
  end
end
