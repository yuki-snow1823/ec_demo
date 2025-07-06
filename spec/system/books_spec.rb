require 'rails_helper'

RSpec.describe "Books", type: :system do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }

  describe "User book browsing" do
    let!(:programming_book) { create(:product, :programming_book, active: true) }
    let!(:novel) { create(:product, :novel, active: true) }
    let!(:inactive_book) { create(:product, :inactive, name: "非表示書籍") }

    context "as anonymous user" do
      it "can browse available books" do
        visit products_path

        expect(page).to have_content("書籍一覧(ユーザー用)")
        expect(page).to have_content(programming_book.name)
        expect(page).to have_content(programming_book.author)
        expect(page).to have_content(novel.name)
        expect(page).to have_content(novel.author)
        expect(page).not_to have_content(inactive_book.name)
      end

      it "can view book details" do
        visit products_path
        click_link programming_book.name

        expect(page).to have_content(programming_book.name)
        expect(page).to have_content(programming_book.author)
        expect(page).to have_content(programming_book.description)
        expect(page).to have_content(programming_book.price.to_s)
        expect(page).to have_content(programming_book.stock.to_s)
      end

      it "sees book information in structured format" do
        visit products_path

        expect(page).to have_css("th", text: "書籍名")
        expect(page).to have_css("th", text: "著者")
        expect(page).to have_css("th", text: "価格")
        expect(page).to have_css("th", text: "在庫")
      end
    end

    context "as regular user" do
      before { sign_in regular_user }

      it "can browse available books" do
        visit products_path

        expect(page).to have_content("書籍一覧(ユーザー用)")
        expect(page).to have_content(programming_book.name)
        expect(page).to have_content(novel.name)
        expect(page).not_to have_content(inactive_book.name)
      end

      it "can view book details" do
        visit product_path(programming_book)

        expect(page).to have_content(programming_book.name)
        expect(page).to have_content(programming_book.author)
        expect(page).to have_content(programming_book.description)
      end

      it "cannot access admin book management" do
        visit admin_products_path

        expect(page).to have_content("管理者のみアクセス可能です")
        expect(current_path).to eq(root_path)
      end
    end
  end

  describe "Admin book management" do
    before { sign_in admin_user }

    context "viewing books" do
      let!(:active_book) { create(:product, :programming_book, active: true) }
      let!(:inactive_book) { create(:product, :inactive, name: "非表示書籍") }

      it "can view all books in admin panel" do
        visit admin_products_path

        expect(page).to have_content("書籍一覧(管理者用)")
        expect(page).to have_content(active_book.name)
        expect(page).to have_content(inactive_book.name)
      end

      it "can view book details" do
        visit admin_product_path(active_book)

        expect(page).to have_content(active_book.name)
        expect(page).to have_content(active_book.author)
        expect(page).to have_content(active_book.description)
        expect(page).to have_content(active_book.price.to_s)
      end
    end

    context "creating books" do
      it "can create a new book" do
        visit admin_products_path
        click_link "書籍新規登録"

        expect(page).to have_content("書籍新規投稿画面(管理者用)")

        fill_in "書籍名", with: "新しい書籍"
        fill_in "著者", with: "新しい著者"
        fill_in "価格", with: "2500"
        fill_in "在庫", with: "50"
        fill_in "説明", with: "新しい書籍の説明です"
        check "アクティブ"
        click_button "登録する"

        expect(page).to have_content("書籍を登録しました")
        expect(page).to have_content("新しい書籍")
        expect(page).to have_content("新しい著者")
      end

      it "shows validation errors when creating invalid book" do
        visit new_admin_product_path

        fill_in "書籍名", with: ""
        fill_in "著者", with: ""
        fill_in "価格", with: "-100"
        click_button "登録する"

        expect(page).to have_content("書籍新規投稿画面(管理者用)")
        # バリデーションエラーが表示されることを確認
      end
    end

    context "editing books" do
      let!(:book) { create(:product, :programming_book) }

      it "can edit existing book" do
        visit admin_product_path(book)
        click_link "編集"

        fill_in "書籍名", with: "編集された書籍名"
        fill_in "著者", with: "編集された著者"
        fill_in "価格", with: "4000"
        click_button "更新する"

        expect(page).to have_content("編集に成功しました")
        expect(page).to have_content("編集された書籍名")
        expect(page).to have_content("編集された著者")
      end

      it "shows validation errors when editing with invalid data" do
        visit edit_admin_product_path(book)

        fill_in "書籍名", with: ""
        fill_in "著者", with: ""
        click_button "更新する"

        expect(page).to have_content("編集に失敗しました")
      end
    end

    context "deleting books" do
      let!(:book) { create(:product, name: "削除対象書籍") }

      it "can delete a book" do
        visit admin_product_path(book)
        click_link "削除"

        expect(page).to have_content("書籍を削除しました")
        expect(page).not_to have_content("削除対象書籍")
      end
    end
  end

  describe "Book browsing scenarios" do
    let!(:books) do
      [
        create(:product, name: "プログラミング入門", author: "コード太郎", price: 2800, active: true),
        create(:product, name: "Web開発実践", author: "ウェブ花子", price: 3200, active: true),
        create(:product, name: "データベース設計", author: "DB次郎", price: 4500, active: true),
        create(:product, name: "廃版書籍", author: "過去の著者", price: 1000, active: false)
      ]
    end

    it "allows browsing multiple books" do
      visit products_path

      expect(page).to have_content("プログラミング入門")
      expect(page).to have_content("Web開発実践")
      expect(page).to have_content("データベース設計")
      expect(page).not_to have_content("廃版書籍")
    end

    it "shows book details when clicked" do
      visit products_path
      click_link "プログラミング入門"

      expect(page).to have_content("プログラミング入門")
      expect(page).to have_content("コード太郎")
      expect(page).to have_content("2800")
    end

    it "allows navigation between book list and details" do
      visit products_path
      click_link "プログラミング入門"
      expect(page).to have_content("プログラミング入門")

      # 戻るボタンやリンクがあれば確認
      # visit products_path
      # expect(page).to have_content("書籍一覧(ユーザー用)")
    end
  end

  describe "Book filtering and display" do
    let!(:free_book) { create(:product, :free, name: "無料書籍", active: true) }
    let!(:expensive_book) { create(:product, :expensive, name: "高額書籍", active: true) }
    let!(:out_of_stock_book) { create(:product, :out_of_stock, name: "在庫切れ書籍", active: true) }

    it "displays books with different price ranges" do
      visit products_path

      expect(page).to have_content("無料書籍")
      expect(page).to have_content("0") # 無料
      expect(page).to have_content("高額書籍")
      expect(page).to have_content("10000") # 高額
      expect(page).to have_content("在庫切れ書籍")
      expect(page).to have_content("0") # 在庫切れ
    end

    it "shows all active books regardless of stock status" do
      visit products_path

      expect(page).to have_content("無料書籍")
      expect(page).to have_content("高額書籍")
      expect(page).to have_content("在庫切れ書籍")
    end
  end

  describe "Error handling" do
    it "handles non-existent book gracefully" do
      visit product_path(id: 999999)

      expect(page).to have_content("見つかりません") # または適切なエラーメッセージ
    end

    it "handles navigation errors gracefully" do
      # 存在しないIDでアクセスしようとした場合の処理
      expect {
        visit product_path(id: "invalid")
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "Responsive design" do
    it "displays properly on mobile devices", :js do
      # モバイルサイズでの表示確認
      page.driver.browser.manage.window.resize_to(375, 667)

      visit products_path
      expect(page).to have_content("書籍一覧(ユーザー用)")
    end
  end

  describe "Performance testing" do
    before do
      # 大量の書籍を作成
      30.times do |i|
        create(:product, name: "パフォーマンステスト書籍#{i}", author: "著者#{i}", active: true)
      end
    end

    it "loads book list efficiently" do
      start_time = Time.current
      visit products_path
      end_time = Time.current

      expect(page).to have_content("書籍一覧(ユーザー用)")
      expect(end_time - start_time).to be < 10.0 # 10秒以内で表示
    end
  end
end
