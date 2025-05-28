module Admin::ProductsHelper
  def formatted_stock(product)
    product.stock.zero? ? "在庫切れ" : "#{product.stock} 個"
  end

  def publication_status(product)
    product.active ? "公開" : "非公開"
  end
end
