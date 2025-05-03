FactoryBot.define do
  factory :order_product do
    order { nil }
    product { nil }
    quantity { 1 }
    price { 1 }
  end
end
