module ProductsHelper
  def stock_label(product)
    return "在庫切れ" if product.stock.to_i <= 0
    "#{product.stock} 個"
  end
end
