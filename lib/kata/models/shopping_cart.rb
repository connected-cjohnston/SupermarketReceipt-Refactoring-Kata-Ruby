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
    for product in @product_quantities.keys do
      quantity = @product_quantities[product]
      if offers.key?(product)
        offer = offers[product]
        unit_price = catalog.unit_price(product)
        quantity_as_int = quantity.to_i
        discount = nil

        discount_amt = discount_amt(offer)

        number_of_x = quantity_as_int / discount_amt
        if offer.offer_type == Kata::SpecialOfferType::TWO_FOR_AMOUNT && quantity_as_int >= 2
          discount = handle_two_for_amount(quantity_as_int, discount_amt, offer, quantity, product, unit_price)
        end
        if offer.offer_type == Kata::SpecialOfferType::THREE_FOR_TWO && quantity_as_int > 2
          discount = handle_three_for_amount(quantity, unit_price, number_of_x, product, quantity_as_int)
        end
        if offer.offer_type == Kata::SpecialOfferType::TEN_PERCENT_DISCOUNT
          discount = handle_ten_percent(product, offer, quantity, unit_price)
        end
        if offer.offer_type == Kata::SpecialOfferType::FIVE_FOR_AMOUNT && quantity_as_int >= 5
          discount = handle_five_for_amount(unit_price, quantity, offer, number_of_x, quantity_as_int, product, discount_amt)
        end

        receipt.add_discount(discount) if discount
      end
    end
  end

  def discount_amt(offer)
    return 2 if offer.offer_type == Kata::SpecialOfferType::TWO_FOR_AMOUNT
    return 3 if offer.offer_type == Kata::SpecialOfferType::THREE_FOR_TWO
    return 5 if offer.offer_type == Kata::SpecialOfferType::FIVE_FOR_AMOUNT
    return 1
  end

  def handle_two_for_amount(quantity_as_int, discount_amt, offer, quantity, product, unit_price)
    total = offer.argument * (quantity_as_int / discount_amt) + quantity_as_int % 2 * unit_price
    discount_n = unit_price * quantity - total
    Kata::Discount.new(product, "2 for " + offer.argument.to_s, discount_n)
  end

  def handle_three_for_amount(quantity, unit_price, number_of_x, product, quantity_as_int)
    discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity_as_int % 3 * unit_price)
    Kata::Discount.new(product, "3 for 2", discount_amount)
  end

  def handle_ten_percent(product, offer, quantity, unit_price)
    Kata::Discount.new(product, offer.argument.to_s + "% off", quantity * unit_price * offer.argument / 100.0)
  end

  def handle_five_for_amount(unit_price, quantity, offer, number_of_x, quantity_as_int, product, discount_amt)
    discount_total = unit_price * quantity - (offer.argument * number_of_x + quantity_as_int % 5 * unit_price)
    Kata::Discount.new(product, discount_amt.to_s + " for " + offer.argument.to_s, discount_total)
  end
end
