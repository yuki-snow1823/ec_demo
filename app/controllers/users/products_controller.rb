class Users::ProductsController < ApplicationController
  # 共通の在庫表示ヘルパーを明示的に読み込み
  helper ProductsHelper

  def index
    @products = Product.where(active: true)
  end

  def show
    @product = Product.find(params[:id])
  end
end
