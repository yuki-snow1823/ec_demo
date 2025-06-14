class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_access_only_admin

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:notice] = "書籍を登録しました"
      redirect_to admin_product_path(@product)
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
    @product = Product.find(params[:id])
    if @product.update(product_params)
      flash[:notice] = "編集に成功しました"
      redirect_to admin_product_path(@product)
    else
      flash[:alert] = "編集に失敗しました"
      render :edit
    end
  end

  def destroy
    @product = Product.find_by(id: params[:id])

    if @product&.destroy
      flash[:notice] = "書籍を削除しました"
    else
      flash[:alert] = @product ? "削除に失敗しました" : "書籍が見つかりませんでした"
    end

    redirect_to admin_products_path
  end

  private

  def authorize_access_only_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "管理者のみアクセス可能です"
    end
  end

  def product_params
    params.require(:product).permit(:name, :author, :price, :stock, :description, :active)
  end
end
