class ShoppingCart

  def initialize
    @items = []
    @product_quantities = {}
  end

  def items
    Array.new @items
  end

  def product_quantities
    @product_quantities
  end

  def add_item(product)
    add_item_quantity(product, 1.0)
    nil
  end

  def add_item_quantity(product, quantity)
    @items << ProductQuantity.new(product, quantity)
    if @product_quantities.key?(product)
      product_quantities[product] = product_quantities[product] + quantity
    else
      product_quantities[product] = quantity
    end
  end
end
