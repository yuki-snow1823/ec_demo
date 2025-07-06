FactoryBot.define do
  factory :product do
    name { "サンプル書籍" }
    description { "これはサンプル書籍の説明です。" }
    price { 1000 }
    stock { 10 }
    active { true }
    author { "著者名" }

    trait :inactive do
      active { false }
    end

    trait :free do
      price { 0 }
    end

    trait :out_of_stock do
      stock { 0 }
    end

    trait :expensive do
      price { 10000 }
    end

    trait :programming_book do
      name { "Ruby on Rails入門" }
      description { "Ruby on Railsの基礎から応用まで学べる書籍です。" }
      author { "山田太郎" }
      price { 3500 }
    end

    trait :novel do
      name { "青春小説" }
      description { "感動的な青春小説です。" }
      author { "田中花子" }
      price { 1500 }
    end
  end
end
