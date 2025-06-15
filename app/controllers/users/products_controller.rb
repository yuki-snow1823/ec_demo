class Users::ProductsController < ApplicationController
  def index
<<<<<<< HEAD
    @products = Product.where(active: true)
  end

  def show
    @product = Product.find(params[:id])
=======
>>>>>>> 4fe7621 (users/productsコントローラーの作成)
  end
end
