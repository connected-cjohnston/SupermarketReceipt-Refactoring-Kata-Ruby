class Teller

  def initialize(catalog)
    @catalog = catalog
    @offers = {}
  end

  def add_special_offer(offer_type, product, unit_price)
    @offers[product] = Offer.new(offer_type, product, unit_price)
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
      next unless @offers.key?(product)

      discount = OfferHandler.new(@offers, @catalog, product, the_cart.product_quantities).handle_offer

      receipt.add_discount(discount) if discount
    end
  end
end
