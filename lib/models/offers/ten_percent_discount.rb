class TenPercentDiscount < Offer
  def discount(quantity, unit_price)
    Discount.new(
      self.product,
      self.unit_price.to_s + "% off",
      quantity * unit_price * self.unit_price / 100.0
    )
  end
end
