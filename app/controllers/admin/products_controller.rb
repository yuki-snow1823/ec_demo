class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_access_only_admin

  def index
    @products = Product.all
  end
  private

  def authorize_access_only_admin
    unless current_user&.admin?
      redirect_to root_path
    end
  end
end
