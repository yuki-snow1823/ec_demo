require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :request do
  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:product) { create(:product, :programming_book) }

  describe "GET /admin/products" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "returns success" do
        get admin_products_path
        expect(response).to have_http_status(:success)
      end

      it "displays all products" do
        active_product = create(:product, name: "アクティブ書籍")
        inactive_product = create(:product, :inactive, name: "非アクティブ書籍")

        get admin_products_path

        expect(response.body).to include("アクティブ書籍")
        expect(response.body).to include("非アクティブ書籍")
      end

      it "displays the correct page title" do
        get admin_products_path
        expect(response.body).to include("書籍一覧(管理者用)")
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        get admin_products_path
        expect(response).to redirect_to(root_path)
      end

      it "shows access denied message" do
        get admin_products_path
        follow_redirect!
        expect(response.body).to include("管理者のみアクセス可能です")
      end
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get admin_products_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /admin/products/new" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "returns success" do
        get new_admin_product_path
        expect(response).to have_http_status(:success)
      end

      it "displays the new product form" do
        get new_admin_product_path
        expect(response.body).to include("書籍新規投稿画面(管理者用)")
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        get new_admin_product_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /admin/products" do
    context "when user is admin" do
      before { sign_in admin_user }

      context "with valid parameters" do
        let(:valid_attributes) do
          {
            name: "新しい書籍",
            description: "新しい書籍の説明",
            price: 2000,
            stock: 50,
            active: true,
            author: "新しい著者"
          }
        end

        it "creates a new product" do
          expect {
            post admin_products_path, params: { product: valid_attributes }
          }.to change(Product, :count).by(1)
        end

        it "redirects to the created product" do
          post admin_products_path, params: { product: valid_attributes }
          expect(response).to redirect_to(admin_product_path(Product.last))
        end

        it "displays success message" do
          post admin_products_path, params: { product: valid_attributes }
          follow_redirect!
          expect(response.body).to include("書籍を登録しました")
        end

        it "creates product with correct attributes" do
          post admin_products_path, params: { product: valid_attributes }
          created_product = Product.last
          expect(created_product.name).to eq("新しい書籍")
          expect(created_product.author).to eq("新しい著者")
          expect(created_product.price).to eq(2000)
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) do
          {
            name: "",
            description: "説明",
            price: -100,
            stock: -10,
            active: true,
            author: ""
          }
        end

        it "does not create a new product" do
          expect {
            post admin_products_path, params: { product: invalid_attributes }
          }.not_to change(Product, :count)
        end

        it "renders the new template" do
          post admin_products_path, params: { product: invalid_attributes }
          expect(response.body).to include("書籍新規投稿画面(管理者用)")
        end
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        post admin_products_path, params: { product: { name: "Test" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/products/:id" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "returns success" do
        get admin_product_path(product)
        expect(response).to have_http_status(:success)
      end

      it "displays product details" do
        get admin_product_path(product)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.author)
        expect(response.body).to include(product.price.to_s)
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        get admin_product_path(product)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /admin/products/:id/edit" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "returns success" do
        get edit_admin_product_path(product)
        expect(response).to have_http_status(:success)
      end

      it "displays the edit form with current values" do
        get edit_admin_product_path(product)
        expect(response.body).to include(product.name)
        expect(response.body).to include(product.author)
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        get edit_admin_product_path(product)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH /admin/products/:id" do
    context "when user is admin" do
      before { sign_in admin_user }

      context "with valid parameters" do
        let(:new_attributes) do
          {
            name: "更新された書籍名",
            description: "更新された説明",
            price: 3000,
            stock: 100,
            active: false,
            author: "更新された著者"
          }
        end

        it "updates the product" do
          patch admin_product_path(product), params: { product: new_attributes }
          product.reload
          expect(product.name).to eq("更新された書籍名")
          expect(product.author).to eq("更新された著者")
          expect(product.price).to eq(3000)
        end

        it "redirects to the product" do
          patch admin_product_path(product), params: { product: new_attributes }
          expect(response).to redirect_to(admin_product_path(product))
        end

        it "displays success message" do
          patch admin_product_path(product), params: { product: new_attributes }
          follow_redirect!
          expect(response.body).to include("編集に成功しました")
        end
      end

      context "with invalid parameters" do
        let(:invalid_attributes) do
          {
            name: "",
            price: -100,
            author: ""
          }
        end

        it "does not update the product" do
          original_name = product.name
          patch admin_product_path(product), params: { product: invalid_attributes }
          product.reload
          expect(product.name).to eq(original_name)
        end

        it "renders the edit template" do
          patch admin_product_path(product), params: { product: invalid_attributes }
          expect(response.body).to include("編集に失敗しました")
        end
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        patch admin_product_path(product), params: { product: { name: "Test" } }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /admin/products/:id" do
    context "when user is admin" do
      before { sign_in admin_user }

      it "destroys the product" do
        product_to_delete = create(:product)
        expect {
          delete admin_product_path(product_to_delete)
        }.to change(Product, :count).by(-1)
      end

      it "redirects to products index" do
        delete admin_product_path(product)
        expect(response).to redirect_to(admin_products_path)
      end

      it "displays success message" do
        delete admin_product_path(product)
        follow_redirect!
        expect(response.body).to include("書籍を削除しました")
      end

      context "when product doesn't exist" do
        it "displays error message" do
          delete admin_product_path(id: 999999)
          follow_redirect!
          expect(response.body).to include("書籍が見つかりませんでした")
        end
      end
    end

    context "when user is not admin" do
      before { sign_in regular_user }

      it "redirects to root path" do
        delete admin_product_path(product)
        expect(response).to redirect_to(root_path)
      end

      it "does not delete the product" do
        product_to_delete = create(:product)
        expect {
          delete admin_product_path(product_to_delete)
        }.not_to change(Product, :count)
      end
    end
  end

  describe "edge cases and error handling" do
    before { sign_in admin_user }

    it "handles non-existent product gracefully" do
      get admin_product_path(id: 999999)
      expect(response).to have_http_status(:not_found)
    end

    it "handles product creation with boundary values" do
      attributes = {
        name: "A" * 255,
        description: "D" * 1000,
        price: 0,
        stock: 0,
        active: true,
        author: "A" * 100
      }

      post admin_products_path, params: { product: attributes }
      expect(response).to redirect_to(admin_product_path(Product.last))
    end

    it "handles product update with partial attributes" do
      patch admin_product_path(product), params: { product: { name: "新しい名前のみ" } }
      product.reload
      expect(product.name).to eq("新しい名前のみ")
      expect(product.author).to eq("山田太郎") # 元の値が保持される
    end
  end
end
