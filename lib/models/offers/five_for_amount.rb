class FiveForAmount < Offer
  DISCOUNT_AMT = 5

  def discount(quantity, unit_price)
    return unless quantity >= 5

    number_of_x = quantity.to_i / DISCOUNT_AMT
    discount_total = unit_price * quantity - (self.unit_price * number_of_x + quantity.to_i % 5 * unit_price)

    Discount.new(
      self.product,
      DISCOUNT_AMT.to_s + " for " + self.unit_price.to_s,
      discount_total
    )
  end
end
