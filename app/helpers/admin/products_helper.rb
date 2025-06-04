module Admin::ProductsHelper
  def stock_label(product)
    return "在庫切れ" if product.stock.to_i <= 0
    "#{product.stock} 個"
  end

  def publication_status(product)
    product.active ? "公開" : "非公開"
  end
end
