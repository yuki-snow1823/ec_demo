require 'rails_helper'

RSpec.describe "Books routing", type: :routing do
  describe "User-facing book routes" do
    it "routes to products#index" do
      expect(get: "/products").to route_to(
        controller: "users/products",
        action: "index"
      )
    end

    it "routes to products#show" do
      expect(get: "/products/1").to route_to(
        controller: "users/products",
        action: "show",
        id: "1"
      )
    end

    it "generates products_path" do
      expect(products_path).to eq("/products")
    end

    it "generates product_path" do
      expect(product_path(1)).to eq("/products/1")
    end
  end

  describe "Admin book management routes" do
    it "routes to admin/products#index" do
      expect(get: "/admin/products").to route_to(
        controller: "admin/products",
        action: "index"
      )
    end

    it "routes to admin/products#new" do
      expect(get: "/admin/products/new").to route_to(
        controller: "admin/products",
        action: "new"
      )
    end

    it "routes to admin/products#create" do
      expect(post: "/admin/products").to route_to(
        controller: "admin/products",
        action: "create"
      )
    end

    it "routes to admin/products#show" do
      expect(get: "/admin/products/1").to route_to(
        controller: "admin/products",
        action: "show",
        id: "1"
      )
    end

    it "routes to admin/products#edit" do
      expect(get: "/admin/products/1/edit").to route_to(
        controller: "admin/products",
        action: "edit",
        id: "1"
      )
    end

    it "routes to admin/products#update via PATCH" do
      expect(patch: "/admin/products/1").to route_to(
        controller: "admin/products",
        action: "update",
        id: "1"
      )
    end

    it "routes to admin/products#update via PUT" do
      expect(put: "/admin/products/1").to route_to(
        controller: "admin/products",
        action: "update",
        id: "1"
      )
    end

    it "routes to admin/products#destroy" do
      expect(delete: "/admin/products/1").to route_to(
        controller: "admin/products",
        action: "destroy",
        id: "1"
      )
    end

    it "generates admin_products_path" do
      expect(admin_products_path).to eq("/admin/products")
    end

    it "generates new_admin_product_path" do
      expect(new_admin_product_path).to eq("/admin/products/new")
    end

    it "generates admin_product_path" do
      expect(admin_product_path(1)).to eq("/admin/products/1")
    end

    it "generates edit_admin_product_path" do
      expect(edit_admin_product_path(1)).to eq("/admin/products/1/edit")
    end
  end

  describe "Route constraints and patterns" do
    it "accepts numeric IDs for user product routes" do
      expect(get: "/products/123").to route_to(
        controller: "users/products",
        action: "show",
        id: "123"
      )
    end

    it "accepts numeric IDs for admin product routes" do
      expect(get: "/admin/products/456").to route_to(
        controller: "admin/products",
        action: "show",
        id: "456"
      )
    end

    it "does not route invalid paths" do
      expect(get: "/products/invalid/path").not_to be_routable
    end

    it "does not route admin paths without admin prefix" do
      expect(get: "/products/new").not_to be_routable
    end
  end

  describe "Route helper methods" do
    it "provides correct paths for nested resources" do
      expect(admin_products_path).to eq("/admin/products")
      expect(products_path).to eq("/products")
    end

    it "handles resource IDs properly" do
      product_id = 42
      expect(admin_product_path(product_id)).to eq("/admin/products/#{product_id}")
      expect(product_path(product_id)).to eq("/products/#{product_id}")
    end

    it "generates correct edit paths" do
      product_id = 123
      expect(edit_admin_product_path(product_id)).to eq("/admin/products/#{product_id}/edit")
    end
  end

  describe "RESTful route completeness" do
    it "supports all standard RESTful actions for admin" do
      expect(get: "/admin/products").to be_routable      # index
      expect(get: "/admin/products/new").to be_routable  # new
      expect(post: "/admin/products").to be_routable     # create
      expect(get: "/admin/products/1").to be_routable    # show
      expect(get: "/admin/products/1/edit").to be_routable # edit
      expect(patch: "/admin/products/1").to be_routable  # update
      expect(put: "/admin/products/1").to be_routable    # update
      expect(delete: "/admin/products/1").to be_routable # destroy
    end

    it "supports read-only actions for users" do
      expect(get: "/products").to be_routable     # index
      expect(get: "/products/1").to be_routable   # show
      expect(post: "/products").not_to be_routable    # create - not allowed
      expect(patch: "/products/1").not_to be_routable # update - not allowed
      expect(delete: "/products/1").not_to be_routable # destroy - not allowed
    end
  end
end
