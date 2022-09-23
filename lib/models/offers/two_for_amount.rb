class TwoForAmount < Offer
  DISCOUNT_AMT = 2

  def discount(quantity, unit_price)
    return unless quantity >= 2

    total = self.unit_price * (quantity.to_i / DISCOUNT_AMT) + quantity.to_i % 2 * unit_price
    discount_n = unit_price * quantity - total

    Discount.new(self.product, "2 for " + self.unit_price.to_s, discount_n)
  end
end
