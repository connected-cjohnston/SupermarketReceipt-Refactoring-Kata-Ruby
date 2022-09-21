class Teller

  def initialize(catalog)
    @catalog = catalog
    @offers = {}
  end

  def add_special_offer(offer_type, product, argument)
    @offers[product] = Offer.new(offer_type, product, argument)
  end

  def checks_out_articles_from(the_cart)
    receipt = Receipt.new

    the_cart.items.each do |pq|
      p = pq.product
      quantity = pq.quantity
      unit_price = @catalog.unit_price(p)
      price = quantity * unit_price

      receipt.add_product(p, quantity, unit_price, price)
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
