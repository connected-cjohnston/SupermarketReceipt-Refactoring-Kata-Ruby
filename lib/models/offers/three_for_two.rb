class ThreeForTwo < Offer
  DISCOUNT_AMT = 3

  def discount(quantity, unit_price)
    return unless quantity > 2

    number_of_x = quantity.to_i / DISCOUNT_AMT
    discount_amount = quantity * unit_price - ((number_of_x * 2 * unit_price) + quantity.to_i % 3 * unit_price)

    Discount.new(self.product, "3 for 2", discount_amount)
  end
end
