class Teller

  def initialize(catalog)
    @catalog = catalog
    @offers = {}
  end

  def add_special_offer(offer_type, product, unit_price)
    @offers[product] = Offer.create(offer_type, product, unit_price)
  end

  def checks_out_items_from(the_cart)
    receipt = Receipt.new

    the_cart.items.each do |item|
      unit_price = @catalog.unit_price(item.product)
      price = item.quantity * unit_price

      receipt.add_product(item.product, item.quantity, unit_price, price)
    end

    handle_offers(the_cart, receipt)

    receipt
  end

  def handle_offers(the_cart, receipt)
    the_cart.product_quantities.keys.each do |product|
      offer = @offers[product]
      next unless offer

      discount = offer.discount(
        the_cart.product_quantities[product],
        @catalog.unit_price(product)
      )

      receipt.add_discount(discount) if discount
    end
  end
end
