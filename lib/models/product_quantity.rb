class ProductQuantity
  attr_reader :product, :quantity
  attr_writer :quantity

  def initialize(product, quantity)
    @product = product
    @quantity = quantity
  end
end
