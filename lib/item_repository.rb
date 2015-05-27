require_relative "item"
require_relative "csv_reader"

class ItemRepository
  attr_reader :sales_engine, :items

  def initialize(items = "", sales_engine)
    @sales_engine = sales_engine
    @items ||= items.map { |item| Item.new(item, self) }
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def all
    items
  end

  def random
    items.sample
  end

  def find_by_item_id(id)
    items.find { |item| item.id == id }
  end

  def find_by_name(name)
    items.find { |item| item.name.downcase == name.downcase }
  end

  def find_by_item_description(description)
    items.find { |item| item.description.downcase == description.downcase }
  end

  def find_by_unit_price(unit_price)
    items.find { |item| item.unit_price == unit_price }
  end

  def find_by_merchant_id(merchant_id)
    items.find { |item| item.merchant_id == merchant_id }
  end

  def find_all_by_name(name)
    items.select { |item| item.name == name }
  end

  def find_all_by_description(description)
    items.select { |item| item.description == description}
  end

  def find_all_by_unit_price(price)
    items.select { |item| item.unit_price == price }
  end

  def find_all_by_merchant_id(merchant_id)
    items.select { |item| item.merchant_id == merchant_id}
  end

  def find_merchant_from(merchant_id)
    sales_engine.find_merchant_from(merchant_id)
  end

  def find_invoice_items_from(item_id)
    sales_engine.find_invoice_items_from(item_id)
  end

  def most_revenue(x)
    sales_engine.find_most_revenue_items(x)
  end
end
