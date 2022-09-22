class Offer
  attr_reader :product, :offer_type, :unit_price

  def initialize(offer_type, product, unit_price)
    @offer_type = offer_type
    @unit_price = unit_price
    @product = product
  end
end
