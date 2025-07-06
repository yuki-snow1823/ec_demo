require 'rails_helper'

RSpec.describe Users::ProductsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /products" do
    context "when products exist" do
      let!(:active_book1) { create(:product, :programming_book, active: true) }
      let!(:active_book2) { create(:product, :novel, active: true) }
      let!(:inactive_book) { create(:product, :inactive, name: "非表示書籍") }

      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "displays only active products" do
        get products_path
        expect(response.body).to include(active_book1.name)
        expect(response.body).to include(active_book2.name)
        expect(response.body).not_to include(inactive_book.name)
      end

      it "displays the correct page title" do
        get products_path
        expect(response.body).to include("書籍一覧(ユーザー用)")
      end

      it "displays product details in the list" do
        get products_path
        expect(response.body).to include(active_book1.name)
        expect(response.body).to include(active_book1.author)
        expect(response.body).to include(active_book1.price.to_s)
      end

      it "shows stock information" do
        get products_path
        expect(response.body).to include(active_book1.stock.to_s)
      end

      it "displays products in a table format" do
        get products_path
        expect(response.body).to include("<th>書籍名</th>")
        expect(response.body).to include("<th>著者</th>")
        expect(response.body).to include("<th>価格</th>")
        expect(response.body).to include("<th>在庫</th>")
      end
    end

    context "when no active products exist" do
      let!(:inactive_book) { create(:product, :inactive) }

      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "displays empty state appropriately" do
        get products_path
        expect(response.body).to include("書籍一覧(ユーザー用)")
        expect(response.body).not_to include(inactive_book.name)
      end
    end

    context "when products have different statuses" do
      let!(:free_book) { create(:product, :free, name: "無料書籍") }
      let!(:out_of_stock_book) { create(:product, :out_of_stock, name: "在庫切れ書籍") }
      let!(:expensive_book) { create(:product, :expensive, name: "高額書籍") }

      it "displays all active products regardless of price or stock" do
        get products_path
        expect(response.body).to include("無料書籍")
        expect(response.body).to include("在庫切れ書籍")
        expect(response.body).to include("高額書籍")
      end

      it "displays correct price information" do
        get products_path
        expect(response.body).to include("0") # 無料書籍の価格
        expect(response.body).to include("10000") # 高額書籍の価格
      end

      it "displays correct stock information" do
        get products_path
        expect(response.body).to include("0") # 在庫切れ書籍の在庫
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "shows the same content as anonymous users" do
        create(:product, name: "テスト書籍")
        get products_path
        expect(response.body).to include("テスト書籍")
      end
    end

    context "when user is not signed in" do
      it "returns success" do
        get products_path
        expect(response).to have_http_status(:success)
      end

      it "allows anonymous browsing" do
        create(:product, name: "匿名閲覧可能書籍")
        get products_path
        expect(response.body).to include("匿名閲覧可能書籍")
      end
    end
  end

  describe "GET /products/:id" do
    let(:product) { create(:product, :programming_book) }

    context "when product exists and is active" do
      it "returns success" do
        get product_path(product)
        expect(response).to have_http_status(:success)
      end

      it "displays product details" do
        get product_path(product)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.author)
        expect(response.body).to include(product.description)
        expect(response.body).to include(product.price.to_s)
      end

      it "displays product name prominently" do
        get product_path(product)
        expect(response.body).to include("<b>書籍名</b>")
        expect(response.body).to include(product.name)
      end

      it "displays author information" do
        get product_path(product)
        expect(response.body).to include(product.author)
      end

      it "displays price information" do
        get product_path(product)
        expect(response.body).to include(product.price.to_s)
      end

      it "displays stock information" do
        get product_path(product)
        expect(response.body).to include(product.stock.to_s)
      end

      it "displays description" do
        get product_path(product)
        expect(response.body).to include(product.description)
      end
    end

    context "when product is inactive" do
      let(:inactive_product) { create(:product, :inactive) }

      it "still displays the product" do
        get product_path(inactive_product)
        expect(response).to have_http_status(:success)
        expect(response.body).to include(inactive_product.name)
      end
    end

    context "when product doesn't exist" do
      it "raises not found error" do
        expect {
          get product_path(id: 999999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "with different product types" do
      let(:free_product) { create(:product, :free, name: "無料書籍") }
      let(:expensive_product) { create(:product, :expensive, name: "高額書籍") }

      it "displays free product correctly" do
        get product_path(free_product)
        expect(response.body).to include("無料書籍")
        expect(response.body).to include("0")
      end

      it "displays expensive product correctly" do
        get product_path(expensive_product)
        expect(response.body).to include("高額書籍")
        expect(response.body).to include("10000")
      end
    end

    context "when user is signed in" do
      before { sign_in user }

      it "returns success" do
        get product_path(product)
        expect(response).to have_http_status(:success)
      end

      it "shows the same content as anonymous users" do
        get product_path(product)
        expect(response.body).to include(product.name)
      end
    end

    context "when user is not signed in" do
      it "returns success" do
        get product_path(product)
        expect(response).to have_http_status(:success)
      end

      it "allows anonymous viewing" do
        get product_path(product)
        expect(response.body).to include(product.name)
      end
    end
  end

  describe "product browsing behavior" do
    let!(:books) do
      [
        create(:product, name: "プログラミング入門", author: "山田太郎", price: 2000, active: true),
        create(:product, name: "小説作品", author: "田中花子", price: 1500, active: true),
        create(:product, name: "専門書", author: "佐藤次郎", price: 5000, active: true),
        create(:product, name: "非表示書籍", author: "鈴木一郎", price: 3000, active: false)
      ]
    end

    it "displays multiple books in index" do
      get products_path
      expect(response.body).to include("プログラミング入門")
      expect(response.body).to include("小説作品")
      expect(response.body).to include("専門書")
      expect(response.body).not_to include("非表示書籍")
    end

    it "shows books with different price ranges" do
      get products_path
      expect(response.body).to include("2000")
      expect(response.body).to include("1500")
      expect(response.body).to include("5000")
    end

    it "shows books by different authors" do
      get products_path
      expect(response.body).to include("山田太郎")
      expect(response.body).to include("田中花子")
      expect(response.body).to include("佐藤次郎")
    end

    it "allows individual book viewing" do
      book = books.first
      get product_path(book)
      expect(response.body).to include(book.name)
      expect(response.body).to include(book.author)
      expect(response.body).to include(book.description)
    end
  end

  describe "edge cases" do
    it "handles products with special characters in name" do
      special_product = create(:product, name: "特殊文字!@#$%^&*()書籍")
      get product_path(special_product)
      expect(response).to have_http_status(:success)
      expect(response.body).to include("特殊文字!@#$%^&*()書籍")
    end

    it "handles products with very long names" do
      long_name = "あ" * 100
      long_product = create(:product, name: long_name)
      get product_path(long_product)
      expect(response).to have_http_status(:success)
      expect(response.body).to include(long_name)
    end

    it "handles products with empty description" do
      product = create(:product, description: "")
      get product_path(product)
      expect(response).to have_http_status(:success)
    end

    it "handles products with nil description" do
      product = create(:product, description: nil)
      get product_path(product)
      expect(response).to have_http_status(:success)
    end
  end
end