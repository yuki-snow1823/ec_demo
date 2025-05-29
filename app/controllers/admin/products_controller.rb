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

    private

    def product_params
        params.require(:product).permit(:name, :author, :price, :stock, :description, :active)
    end
end
