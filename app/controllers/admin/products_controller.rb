class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_access_only_admin

  def index
    @products = Product.all
  end

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

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
<<<<<<< HEAD
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "編集に成功しました"
      redirect_to root_path # // TODO: 完成次第一覧画面や詳細画面に変更する？
    else
      flash[:alert] = "編集に失敗しました"
      render :edit
    end
=======
    product = Product.find(params[:id])
    product.update(product_params)
    redirect_to root_path # // TODO: 完成次第一覧画面や詳細画面に変更する？
>>>>>>> d61047f (コメントアウトに検索性向上のためtodoを追加)
  end

  private

  def authorize_access_only_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end

  def product_params
    params.require(:product).permit(:name, :author, :price, :stock, :description, :active)
  end
end
