class Product
  EACH = :each
  KILO = :kilo

  attr_reader :name, :unit

  def initialize(name, unit)
    @name = name
    @unit = unit
  end
end
