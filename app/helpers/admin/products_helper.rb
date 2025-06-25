module Admin::ProductsHelper
  def publication_status(product)
    product.active ? "公開" : "非公開"
  end
end
