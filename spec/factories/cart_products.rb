FactoryBot.define do
  factory :cart_product do
    cart { nil }
    product { nil }
    quantity { 1 }
  end
end
