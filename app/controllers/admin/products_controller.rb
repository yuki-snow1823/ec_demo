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

  private

  def product_params
    params.require(:product).permit(:name, :author, :price, :stock, :description, :active)
  end


  def authorize_access_only_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end
end
