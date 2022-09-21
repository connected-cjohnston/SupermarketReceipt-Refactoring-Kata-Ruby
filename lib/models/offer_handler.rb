class OfferHandler

  attr_reader :offers, :catalog, :product, :product_quantities

  def initialize(offers, catalog, product, product_quantities)
    @offers = offers
    @catalog = catalog
    @product = product
    @product_quantities = product_quantities
  end

  def handle_offer
    return handle_two_for_amount if two_for_amount_offer?
    return handle_three_for_two if three_for_two_offer?
    return handle_ten_percent if ten_percent_discount_offer?
    return handle_five_for_amount if five_for_amount_offer?
  end

  private

  def quantity
    @quantity = product_quantities[product]
  end

  def offer
    @offer = offers[product]
  end

  def unit_price
    @unit_price = catalog.unit_price(product)
  end

  def quantity_as_int
    @quantity_as_int = quantity.to_i
  end

  def discount_amt
    return 2 if offer.offer_type == SpecialOfferType::TWO_FOR_AMOUNT
    return 3 if offer.offer_type == SpecialOfferType::THREE_FOR_TWO
    return 5 if offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT
    return 1
  end

  def number_of_x
    @number_of_x = quantity_as_int / discount_amt
  end

  # -------------------- hmmmm......
  def two_for_amount_offer?
    offer.offer_type == SpecialOfferType::TWO_FOR_AMOUNT && quantity_as_int >= 2
  end

  def three_for_two_offer?
    offer.offer_type == SpecialOfferType::THREE_FOR_TWO && quantity_as_int > 2
  end

  def ten_percent_discount_offer?
    offer.offer_type == SpecialOfferType::TEN_PERCENT_DISCOUNT
  end

  def five_for_amount_offer?
    offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT && quantity_as_int >= 5
  end

  def handle_two_for_amount
    total = offer.argument * (quantity_as_int / discount_amt) + quantity_as_int % 2 * unit_price
    discount_n = unit_price * quantity - total
    Discount.new(product, "2 for " + offer.argument.to_s, discount_n)
  end

  def handle_three_for_two
    discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity_as_int % 3 * unit_price)
    Discount.new(product, "3 for 2", discount_amount)
  end

  def handle_ten_percent
    Discount.new(product, offer.argument.to_s + "% off", quantity * unit_price * offer.argument / 100.0)
  end

  def handle_five_for_amount
    discount_total = unit_price * quantity - (offer.argument * number_of_x + quantity_as_int % 5 * unit_price)
    Discount.new(product, discount_amt.to_s + " for " + offer.argument.to_s, discount_total)
  end
end
