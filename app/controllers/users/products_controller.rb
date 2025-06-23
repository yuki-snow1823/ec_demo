class Users::ProductsController < ApplicationController
  def index
    @products = Product.where(active: true)
  end

  def show
    @product = Product.find(params[:id])
  end
end
