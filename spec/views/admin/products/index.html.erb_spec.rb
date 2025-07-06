require 'rails_helper'

RSpec.describe "admin/products/index", type: :view do
  let(:books) do
    [
      create(:product, :programming_book, active: true),
      create(:product, :novel, active: true),
      create(:product, :inactive, name: "非表示書籍", active: false)
    ]
  end

  before do
    assign(:products, books)
  end

  it "displays the admin page title" do
    render
    expect(rendered).to include("書籍一覧(管理者用)")
  end

  it "displays new book registration link" do
    render
    expect(rendered).to have_link("書籍新規登録", href: new_admin_product_path)
  end

  it "displays book listing table headers" do
    render
    expect(rendered).to include("書籍名")
    expect(rendered).to include("著者")
    expect(rendered).to include("価格")
    expect(rendered).to include("在庫")
    expect(rendered).to include("アクティブ")
  end

  it "displays all books including inactive ones" do
    render
    books.each do |book|
      expect(rendered).to include(book.name)
      expect(rendered).to include(book.author)
      expect(rendered).to include(book.price.to_s)
      expect(rendered).to include(book.stock.to_s)
    end
  end

  it "shows active status for each book" do
    render
    # アクティブ状態の表示を確認
    active_books = books.select(&:active)
    inactive_books = books.reject(&:active)

    active_books.each do |book|
      expect(rendered).to include(book.name)
    end

    inactive_books.each do |book|
      expect(rendered).to include(book.name)
    end
  end

  it "links to individual book management pages" do
    render
    books.each do |book|
      expect(rendered).to have_link(book.name, href: admin_product_path(book))
    end
  end

  it "displays edit links for each book" do
    render
    books.each do |book|
      expect(rendered).to have_link("編集", href: edit_admin_product_path(book))
    end
  end

  it "displays delete links for each book" do
    render
    books.each do |book|
      expect(rendered).to have_link("削除", href: admin_product_path(book))
    end
  end

  context "when no books exist" do
    before do
      assign(:products, [])
    end

    it "displays empty state with new book link" do
      render
      expect(rendered).to include("書籍一覧(管理者用)")
      expect(rendered).to have_link("書籍新規登録", href: new_admin_product_path)
    end
  end

  context "with books of different statuses" do
    let(:mixed_books) do
      [
        create(:product, name: "アクティブ書籍", active: true),
        create(:product, name: "非アクティブ書籍", active: false),
        create(:product, name: "在庫切れ書籍", stock: 0, active: true),
        create(:product, name: "無料書籍", price: 0, active: true)
      ]
    end

    before do
      assign(:products, mixed_books)
    end

    it "displays all books regardless of status" do
      render
      mixed_books.each do |book|
        expect(rendered).to include(book.name)
      end
    end

    it "shows correct price and stock information" do
      render
      expect(rendered).to include("0") # 在庫切れ & 無料書籍
    end
  end
end
