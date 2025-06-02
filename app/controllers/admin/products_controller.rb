class Admin::ProductsController < ApplicationController
  def new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    product = Product.find(product_params)
    product.destroy
    flash[:notice] = "書籍を削除しました"
    redirect_to root_path # // TODO: 完成次第一覧画面に変更する？
  end

  private

  def product_params
    params.require(:product).permit(:name, :author, :price, :stock, :description, :active)
  end
end
