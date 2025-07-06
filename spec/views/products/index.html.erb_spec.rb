require 'rails_helper'

RSpec.describe "products/index", type: :view do
  let(:active_books) do
    [
      create(:product, :programming_book, active: true),
      create(:product, :novel, active: true),
      create(:product, :free, name: "無料書籍", active: true)
    ]
  end

  before do
    assign(:products, active_books)
  end

  it "displays the page title" do
    render
    expect(rendered).to include("書籍一覧(ユーザー用)")
  end

  it "displays book listing table headers" do
    render
    expect(rendered).to include("書籍名")
    expect(rendered).to include("著者")
    expect(rendered).to include("価格")
    expect(rendered).to include("在庫")
  end

  it "displays all active books" do
    render
    active_books.each do |book|
      expect(rendered).to include(book.name)
      expect(rendered).to include(book.author)
      expect(rendered).to include(book.price.to_s)
      expect(rendered).to include(book.stock.to_s)
    end
  end

  it "links to individual book pages" do
    render
    active_books.each do |book|
      expect(rendered).to have_link(book.name, href: product_path(book))
    end
  end

  context "when no books are available" do
    before do
      assign(:products, [])
    end

    it "displays empty state gracefully" do
      render
      expect(rendered).to include("書籍一覧(ユーザー用)")
      # 空の状態でも適切にレンダリングされる
    end
  end

  context "with books of different characteristics" do
    let(:special_books) do
      [
        create(:product, name: "特殊文字!@#$%書籍", author: "特殊著者", price: 0, stock: 0),
        create(:product, name: "長い書籍名" * 10, author: "長い著者名" * 5, price: 999999, stock: 1000)
      ]
    end

    before do
      assign(:products, special_books)
    end

    it "handles books with special characters" do
      render
      expect(rendered).to include("特殊文字!@#$%書籍")
      expect(rendered).to include("特殊著者")
    end

    it "handles books with extreme values" do
      render
      expect(rendered).to include("999999")
      expect(rendered).to include("1000")
      expect(rendered).to include("0")
    end

    it "handles books with long names" do
      render
      expect(rendered).to include("長い書籍名")
      expect(rendered).to include("長い著者名")
    end
  end
end
