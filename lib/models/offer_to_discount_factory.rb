class OfferToDiscountFactory

  attr_reader :offer, :catalog, :product, :product_quantities

  def initialize(offer, catalog, product, product_quantities)
    @offer = offer
    @catalog = catalog
    @product = product
    @product_quantities = product_quantities
  end

  def handle_offer
    return create_two_for_amount_discount if two_for_amount_offer?
    return create_handle_three_for_two_discount if three_for_two_offer?
    return create_handle_five_for_amount_discount if five_for_amount_offer?
    return create_handle_ten_percent_discount if ten_percent_discount_offer?
  end

  private

  def quantity
    @quantity = product_quantities[product]
  end

  # --------------------
  def two_for_amount_offer?
    offer.offer_type == SpecialOfferType::TWO_FOR_AMOUNT && quantity >= 2
  end

  def three_for_two_offer?
    offer.offer_type == SpecialOfferType::THREE_FOR_TWO && quantity > 2
  end

  def ten_percent_discount_offer?
    offer.offer_type == SpecialOfferType::TEN_PERCENT_DISCOUNT
  end

  def five_for_amount_offer?
    offer.offer_type == SpecialOfferType::FIVE_FOR_AMOUNT && quantity >= 5
  end

  # --------------------
  def unit_price
    @unit_price = catalog.unit_price(product)
  end

  def create_two_for_amount_discount
    discount_amt = 2
    total = offer.unit_price * (quantity.to_i / discount_amt) + quantity.to_i % 2 * unit_price
    discount_n = unit_price * quantity - total
    Discount.new(offer.product, "2 for " + offer.unit_price.to_s, discount_n)
  end

  def create_handle_three_for_two_discount
    discount_amt = 3
    number_of_x = quantity.to_i / discount_amt
    discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity.to_i % 3 * unit_price)
    Discount.new(offer.product, "3 for 2", discount_amount)
  end

  def create_handle_five_for_amount_discount
    discount_amt = 5
    number_of_x = quantity.to_i / discount_amt
    discount_total = unit_price * quantity - (offer.unit_price * number_of_x + quantity.to_i % 5 * unit_price)
    Discount.new(offer.product, discount_amt.to_s + " for " + offer.unit_price.to_s, discount_total)
  end

  def create_handle_ten_percent_discount
    Discount.new(offer.product, offer.unit_price.to_s + "% off", quantity * unit_price * offer.unit_price / 100.0)
  end
end
