class ProductsController < ApplicationController
  before_action :authenticate_user!   # ログインチェック
  before_action :check_admin          # admin: true か
  def index
    @products = Product.all
  end
  private

  def check_admin
    unless current_user&.admin?
      redirect_to root_path # トップページに戻す
    end
  end
end
