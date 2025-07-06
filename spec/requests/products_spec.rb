require 'rails_helper'

RSpec.describe "Products", type: :request do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  describe "GET /products" do
    let!(:active_books) do
      [
        create(:product, :programming_book, active: true),
        create(:product, :novel, active: true),
        create(:product, :free, name: "無料書籍", active: true)
      ]
    end
    let!(:inactive_book) { create(:product, :inactive, name: "非表示書籍") }

    it "returns http success" do
      get products_path
      expect(response).to have_http_status(:success)
    end

    it "displays only active books" do
      get products_path
      active_books.each do |book|
        expect(response.body).to include(book.name)
      end
      expect(response.body).not_to include(inactive_book.name)
    end

    it "displays book information in a structured format" do
      get products_path
      expect(response.body).to include("書籍一覧(ユーザー用)")
      expect(response.body).to include("<th>書籍名</th>")
      expect(response.body).to include("<th>著者</th>")
      expect(response.body).to include("<th>価格</th>")
    end

    it "shows books with different price ranges" do
      get products_path
      expect(response.body).to include("0") # 無料書籍
      expect(response.body).to include("3500") # プログラミング書籍
      expect(response.body).to include("1500") # 小説
    end

    context "when no active books exist" do
      before { Product.update_all(active: false) }

      it "returns success with empty list" do
        get products_path
        expect(response).to have_http_status(:success)
        expect(response.body).to include("書籍一覧(ユーザー用)")
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "displays the same content as anonymous users" do
        get products_path
        active_books.each do |book|
          expect(response.body).to include(book.name)
        end
      end
    end

    context "when admin user is signed in" do
      before { sign_in admin_user }

      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "displays the same content as regular users" do
        get products_path
        active_books.each do |book|
          expect(response.body).to include(book.name)
        end
      end
    end
  end

  describe "GET /products/:id" do
    let(:book) { create(:product, :programming_book) }

    it "returns http success" do
      get product_path(book)
      expect(response).to have_http_status(:success)
    end

    it "displays detailed book information" do
      get product_path(book)
      expect(response.body).to include(book.name)
      expect(response.body).to include(book.author)
      expect(response.body).to include(book.description)
      expect(response.body).to include(book.price.to_s)
      expect(response.body).to include(book.stock.to_s)
    end

    it "displays book name prominently" do
      get product_path(book)
      expect(response.body).to include("<b>書籍名</b>")
    end

    context "when book is inactive" do
      let(:inactive_book) { create(:product, :inactive) }

      it "still displays the book" do
        get product_path(inactive_book)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(inactive_book.name)
      end
    end

    context "when book doesn't exist" do
      it "raises not found error" do
        expect {
          get product_path(id: 999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "returns success" do
        get product_path(book)
        expect(response).to have_http_status(:success)
      end

      it "shows detailed book information" do
        get product_path(book)
        expect(response.body).to include(book.name)
        expect(response.body).to include(book.author)
      end
    end
  end

  describe "book browsing integration" do
    let!(:programming_books) do
      [
        create(:product, name: "Ruby基礎", author: "Ruby太郎", price: 2500, active: true),
        create(:product, name: "Rails実践", author: "Rails花子", price: 3500, active: true)
      ]
    end
    let!(:novels) do
      [
        create(:product, name: "青春物語", author: "小説家一郎", price: 1200, active: true),
        create(:product, name: "推理小説", author: "推理作家", price: 1800, active: true)
      ]
    end
    let!(:inactive_books) do
      [
        create(:product, name: "廃版書籍", author: "過去の著者", price: 5000, active: false)
      ]
    end

    it "allows browsing from index to detail pages" do
      # 書籍一覧ページにアクセス
      get products_path
      expect(response).to have_http_status(:success)
      
      # プログラミング書籍が表示されることを確認
      programming_books.each do |book|
        expect(response.body).to include(book.name)
        expect(response.body).to include(book.author)
      end
      
      # 小説も表示されることを確認
      novels.each do |book|
        expect(response.body).to include(book.name)
        expect(response.body).to include(book.author)
      end
      
      # 非アクティブな書籍は表示されないことを確認
      inactive_books.each do |book|
        expect(response.body).not_to include(book.name)
      end
    end

    it "displays correct book information on detail pages" do
      programming_books.each do |book|
        get product_path(book)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(book.name)
        expect(response.body).to include(book.author)
        expect(response.body).to include(book.price.to_s)
        expect(response.body).to include(book.description)
      end
    end

    it "shows books with different characteristics" do
      get products_path
      
      # 異なる価格帯の書籍が表示される
      expect(response.body).to include("2500")
      expect(response.body).to include("3500")
      expect(response.body).to include("1200")
      expect(response.body).to include("1800")
      
      # 異なる著者の書籍が表示される
      expect(response.body).to include("Ruby太郎")
      expect(response.body).to include("Rails花子")
      expect(response.body).to include("小説家一郎")
      expect(response.body).to include("推理作家")
    end
  end

  describe "performance and scalability" do
    before do
      # 大量の書籍を作成
      50.times do |i|
        create(:product, name: "書籍#{i}", author: "著者#{i}", price: (i + 1) * 100, active: true)
      end
    end

    it "handles large number of books efficiently" do
      start_time = Time.current
      get products_path
      end_time = Time.current
      
      expect(response).to have_http_status(:success)
      expect(end_time - start_time).to be < 5.0 # 5秒以内で応答
    end

    it "displays all active books in the list" do
      get products_path
      expect(response.body).to include("書籍0")
      expect(response.body).to include("書籍49")
    end
  end

  describe "error handling" do
    it "gracefully handles database errors" do
      # データベースエラーをシミュレート
      allow(Product).to receive(:where).and_raise(ActiveRecord::ConnectionNotEstablished)
      
      expect {
        get products_path
      }.to raise_error(ActiveRecord::ConnectionNotEstablished)
    end

    it "handles malformed product IDs" do
      expect {
        get product_path(id: "invalid")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
