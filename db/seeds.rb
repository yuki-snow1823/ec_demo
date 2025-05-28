  # This file should ensure the existence of records required to run the application in every environment (production,
  # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
  # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
  #
  # Example:
  #
  #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  #     MovieGenre.find_or_create_by!(name: genre_name)
  #   end

  books = [
  { name: "書籍名1", description: "書籍の説明です。", price: 0,    stock: 0,   active: true  },
  { name: "書籍名2", description: "書籍の説明です。", price: 100,  stock: 10,  active: false },
  { name: "書籍名3", description: "書籍の説明です。", price: 350,  stock: 35,  active: true  },
  { name: "書籍名4", description: "書籍の説明です。", price: 1000, stock: 100, active: false },
  { name: "書籍名5", description: "書籍の説明です。", price: 3500, stock: 1000, active: true  }
]

books.each do |attrs|
  Product.create!(attrs)
end
