class ReceiptPrinter

  def initialize(columns = 40)
    @columns = columns
  end

  def print_receipt(receipt)
    result = ""

    add_items(receipt, result)
    add_discounts(receipt, result)
    add_totals(receipt, result)

    result.to_s
  end

  private

  def add_discounts(receipt, result)
    receipt.discounts.each { |discount| add_discount(discount, result) }
  end

  def add_items(receipt, result)
    receipt.items.each { |item| add_item(item, result) }
  end

  def add_totals(receipt, result)
    result.concat("\n")
    price_presentation = "%.2f" % receipt.total_price.to_f
    total = "Total: "
    whitespace = whitespace(@columns - total.size - price_presentation.size)
    result.concat(total, whitespace, price_presentation)
  end

  def add_item(item, result)
    price = "%.2f" % item.total_price
    quantity = present_quantity(item)
    name = item.product.name
    unit_price = "%.2f" % item.price

    whitespace_size = @columns - name.size - price.size
    line = name + whitespace(whitespace_size) + price + "\n"

    if item.quantity != 1
      line += "  #{unit_price} * #{quantity}\n"
    end

    result.concat(line)
  end

  def add_discount(discount, result)
    product_presentation = discount.product.name
    price_presentation = "%.2f" % discount.discount_amount
    description = discount.description

    result.concat(description)
    result.concat("(")
    result.concat(product_presentation)
    result.concat(")")
    result.concat(whitespace(@columns - 3 - product_presentation.size - description.size - price_presentation.size))
    result.concat("-")
    result.concat(price_presentation)
    result.concat("\n")
  end

  def present_quantity(item)
    Product::EACH == item.product.unit ? '%x' % item.quantity.to_i : '%.3f' % item.quantity
  end

  def whitespace(size)
    size.times.map { ' ' }.join('')
  end
end
