  # This file should ensure the existence of records required to run the application in every environment (production,
  # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
  # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
  #
  # Example:
  #
  #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
  #     MovieGenre.find_or_create_by!(name: genre_name)
  #   end

  prices = [ 0, 100, 350, 1000, 3500 ]
  stocks = [ 0, 10, 35, 100, 1000 ]
  active = [ true, false, true, false, true ]
  5.times do |n|
    Product.create!(
      name: "書籍名#{n + 1}",
      description: "書籍の説明です。書籍の説明です。書籍の説明です。書籍の説明です。",
      price: prices[n],
      stock: stocks[n],
      active: active[n]
    )
  end
