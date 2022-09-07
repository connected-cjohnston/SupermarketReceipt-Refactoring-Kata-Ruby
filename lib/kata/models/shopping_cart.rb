class Kata::ShoppingCart

  def initialize
    @items = []
    @product_quantities = {}

    @discount_quantities = Hash.new(1).tap do |h|
      h[Kata::SpecialOfferType::THREE_FOR_TWO] = 3
      h[Kata::SpecialOfferType::TWO_FOR_AMOUNT] = 2
      h[Kata::SpecialOfferType::FIVE_FOR_AMOUNT] = 5
    end
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
    for product_quantity in @product_quantities.keys do
      quantity = @product_quantities[product_quantity]
      if offers.key?(product_quantity)
        offer = offers[product_quantity]
        unit_price = catalog.unit_price(product_quantity)
        quantity_as_int = quantity.to_i
        discount = nil

        discount_quantity = @discount_quantities[offer.offer_type]

        number_of_x = quantity_as_int / discount_quantity
        if offer.offer_type == Kata::SpecialOfferType::TWO_FOR_AMOUNT && quantity_as_int >= 2
            total = offer.argument * (quantity_as_int / discount_quantity) + quantity_as_int % 2 * unit_price
            discount_n = unit_price * quantity - total
            discount = Kata::Discount.new(product_quantity, "2 for " + offer.argument.to_s, discount_n)
          end
        if offer.offer_type == Kata::SpecialOfferType::THREE_FOR_TWO && quantity_as_int > 2
          discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity_as_int % 3 * unit_price)
          discount = Kata::Discount.new(product_quantity, "3 for 2", discount_amount)
        end
        if offer.offer_type == Kata::SpecialOfferType::TEN_PERCENT_DISCOUNT
          discount = Kata::Discount.new(product_quantity, offer.argument.to_s + "% off", quantity * unit_price * offer.argument / 100.0)
        end
        if offer.offer_type == Kata::SpecialOfferType::FIVE_FOR_AMOUNT && quantity_as_int >= 5
          discount_total = unit_price * quantity - (offer.argument * number_of_x + quantity_as_int % 5 * unit_price)
          discount = Kata::Discount.new(product_quantity, discount_quantity.to_s + " for " + offer.argument.to_s, discount_total)
        end

        receipt.add_discount(discount) if discount
      end
    end
  end
end
