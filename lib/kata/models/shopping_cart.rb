class Kata::ShoppingCart

  def initialize
    @items = []
    @product_quantities = {}
  end

  def items
    Array.new @items
  end

  def add_item(product)
    add_item_quantity(product, 1.0)
    nil
  end

  def product_quantities
    @product_quantities
  end

  def add_item_quantity(product, quantity)
    @items << Kata::ProductQuantity.new(product, quantity)
    if @product_quantities.key?(product)
      product_quantities[product] = product_quantities[product] + quantity
    else
      product_quantities[product] = quantity
    end
  end

  def handle_offers(receipt, offers, catalog)
    @product_quantities.keys.each do |product|
      next unless offers.key?(product)

      discount = Kata::OfferHandler.new(offers, catalog, product, product_quantities).handle_offer

      receipt.add_discount(discount) if discount
    end
  end
end
