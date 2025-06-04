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
    product = Product.find(product_params)
    product.destroy
    flash[:notice] = "書籍を削除しました"
    redirect_to admin_product_path(@product)
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
