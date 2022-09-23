class Offer
  TWO_FOR_AMOUNT = :two_for_amount
  THREE_FOR_TWO = :three_for_two
  FIVE_FOR_AMOUNT = :five_for_amount
  TEN_PERCENT_DISCOUNT = :ten_percent

  attr_reader :product, :unit_price

  def initialize(product, unit_price)
    @unit_price = unit_price
    @product = product
  end

  def discount(quantity, unit_price)
    raise NotImplementedError
  end

  def self.create(offer_type, product, unit_price)
    {
      TWO_FOR_AMOUNT => TwoForAmount,
      THREE_FOR_TWO => ThreeForTwo,
      FIVE_FOR_AMOUNT => FiveForAmount,
      TEN_PERCENT_DISCOUNT => TenPercentDiscount,
    }[offer_type].new(product, unit_price)
  end
end
