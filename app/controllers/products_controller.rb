class ProductsController < ApplicationController
  def index
    @products = Product.where("active = ?", true)
  end
end
