module BooksTestHelpers
  # Helper methods for book-related testing

  def create_sample_books
    {
      programming: create(:product, :programming_book, active: true),
      novel: create(:product, :novel, active: true),
      inactive: create(:product, :inactive, name: "非表示書籍"),
      free: create(:product, :free, name: "無料書籍", active: true),
      expensive: create(:product, :expensive, name: "高額書籍", active: true),
      out_of_stock: create(:product, :out_of_stock, name: "在庫切れ書籍", active: true)
    }
  end

  def create_admin_user_and_sign_in
    admin = create(:user, :admin)
    sign_in admin
    admin
  end

  def create_regular_user_and_sign_in
    user = create(:user)
    sign_in user
    user
  end

  def expect_book_list_page_content(books_to_include: [], books_to_exclude: [])
    expect(page).to have_content("書籍一覧")
    
    books_to_include.each do |book|
      expect(page).to have_content(book.name)
      expect(page).to have_content(book.author)
    end
    
    books_to_exclude.each do |book|
      expect(page).not_to have_content(book.name)
    end
  end

  def expect_book_detail_page_content(book)
    expect(page).to have_content(book.name)
    expect(page).to have_content(book.author)
    expect(page).to have_content(book.description)
    expect(page).to have_content(book.price.to_s)
    expect(page).to have_content(book.stock.to_s)
  end

  def expect_admin_page_content
    expect(page).to have_content("管理者用")
    expect(page).to have_link("書籍新規登録")
  end

  def expect_access_denied_message
    expect(page).to have_content("管理者のみアクセス可能です")
    expect(current_path).to eq(root_path)
  end

  def fill_in_book_form(attributes = {})
    default_attributes = {
      name: "テスト書籍",
      author: "テスト著者",
      price: "2000",
      stock: "50",
      description: "テスト説明"
    }
    
    attrs = default_attributes.merge(attributes)
    
    fill_in "書籍名", with: attrs[:name]
    fill_in "著者", with: attrs[:author]
    fill_in "価格", with: attrs[:price]
    fill_in "在庫", with: attrs[:stock]
    fill_in "説明", with: attrs[:description]
    
    if attrs[:active]
      check "アクティブ"
    elsif attrs[:active] == false
      uncheck "アクティブ"
    end
  end

  def expect_book_creation_success(book_name)
    expect(page).to have_content("書籍を登録しました")
    expect(page).to have_content(book_name)
  end

  def expect_book_update_success(book_name)
    expect(page).to have_content("編集に成功しました")
    expect(page).to have_content(book_name)
  end

  def expect_book_deletion_success
    expect(page).to have_content("書籍を削除しました")
  end

  def expect_validation_errors
    expect(page).to have_content("エラー") # または適切なエラーメッセージ
  end

  # Database helper methods
  def ensure_clean_database
    Product.destroy_all
    User.destroy_all
  end

  def create_books_with_different_statuses
    active_books = [
      create(:product, name: "アクティブ書籍1", active: true),
      create(:product, name: "アクティブ書籍2", active: true)
    ]
    
    inactive_books = [
      create(:product, name: "非アクティブ書籍1", active: false),
      create(:product, name: "非アクティブ書籍2", active: false)
    ]
    
    { active: active_books, inactive: inactive_books }
  end

  def create_books_with_edge_cases
    [
      create(:product, name: "A", author: "著者", price: 0, stock: 0),
      create(:product, name: "長い名前" * 50, author: "長い著者名" * 20, price: 999999, stock: 999999),
      create(:product, name: "特殊文字!@#$%^&*()", author: "特殊文字著者", price: 1000, stock: 10)
    ]
  end

  # Performance testing helpers
  def measure_page_load_time(&block)
    start_time = Time.current
    yield
    end_time = Time.current
    end_time - start_time
  end

  def create_many_books(count = 50)
    count.times do |i|
      create(:product, 
        name: "書籍#{i}",
        author: "著者#{i}",
        price: (i + 1) * 100,
        stock: (i + 1) * 10,
        active: true
      )
    end
  end

  # API testing helpers (if needed for future API endpoints)
  def json_response
    JSON.parse(response.body)
  end

  def expect_json_response_to_include_books(books)
    books.each do |book|
      expect(json_response).to include(
        hash_including(
          "name" => book.name,
          "author" => book.author,
          "price" => book.price
        )
      )
    end
  end
end

RSpec.configure do |config|
  config.include BooksTestHelpers
end