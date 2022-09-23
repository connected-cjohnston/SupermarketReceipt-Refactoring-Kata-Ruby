class Offer
  attr_reader :product, :unit_price

  def initialize(product, unit_price)
    @unit_price = unit_price
    @product = product
  end

  def discount(quantity, unit_price)
    raise NotImplementedError
  end

  def self.create(offer_type, product, unit_price)
    return TwoForAmount.new(product, unit_price) if offer_type == SpecialOfferType::TWO_FOR_AMOUNT
    return ThreeForTwo.new(product, unit_price) if offer_type == SpecialOfferType::THREE_FOR_TWO
    return FiveForAmount.new(product, unit_price) if offer_type == SpecialOfferType::FIVE_FOR_AMOUNT
    return TenPercentDiscount.new(product, unit_price) if offer_type == SpecialOfferType::TEN_PERCENT_DISCOUNT
  end
end

class TwoForAmount < Offer
  DISCOUNT_AMT = 2
  def discount(quantity, unit_price)
    return unless quantity >= 2

    total = self.unit_price * (quantity.to_i / DISCOUNT_AMT) + quantity.to_i % 2 * unit_price
    discount_n = unit_price * quantity - total
    Discount.new(self.product, "2 for " + self.unit_price.to_s, discount_n)
  end
end

class ThreeForTwo < Offer
  DISCOUNT_AMT = 3

  def discount(quantity, unit_price)
    return unless quantity > 2

    number_of_x = quantity.to_i / DISCOUNT_AMT
    discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity.to_i % 3 * unit_price)
    Discount.new(self.product, "3 for 2", discount_amount)
  end
end

class FiveForAmount < Offer
  DISCOUNT_AMT = 5
  def discount(quantity, unit_price)
    return unless quantity >= 5

    number_of_x = quantity.to_i / DISCOUNT_AMT
    discount_total = unit_price * quantity - (self.unit_price * number_of_x + quantity.to_i % 5 * unit_price)
    Discount.new(self.product, DISCOUNT_AMT.to_s + " for " + self.unit_price.to_s, discount_total)
  end
end

class TenPercentDiscount < Offer
  def discount(quantity, unit_price)
    Discount.new(self.product, self.unit_price.to_s + "% off", quantity * unit_price * self.unit_price / 100.0)
  end
end

