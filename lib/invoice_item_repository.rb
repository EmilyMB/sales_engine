require_relative 'invoice_item'
require_relative 'office_repository'

class InvoiceItemRepository < OfficeRepository
  attr_reader :sales_engine, :data

  def initialize(invoice_items, parent)
    @data ||= invoice_items.map {|inv_item| InvoiceItem.new(inv_item, self)}
    @sales_engine = parent
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def find_by_item_id(criteria)
    generic_non_string_find("item_id", criteria)
  end

  def find_by_invoice_id(criteria)
    generic_non_string_find("invoice_id", criteria)
  end

  def find_by_quantity(criteria)
    generic_non_string_find("quantity", criteria)
  end

  def find_by_unit_price(criteria)
    generic_non_string_find("unit_price", criteria)
  end

  def find_all_by_item_id(criteria)
    generic_non_string_find_all("item_id", criteria)
  end

  def find_all_by_unit_price(criteria)
    generic_non_string_find_all("unit_price", criteria)
  end

  def find_all_by_invoice_id(criteria)
    generic_non_string_find_all("invoice_id", criteria)
  end

  def find_all_by_quantity(criteria)
    generic_non_string_find_all("quantity", criteria)
  end

  def find_item_from(id)
    sales_engine.find_item_from(id)
  end

  def find_invoice_from(id)
    sales_engine.find_invoice_from(id)
  end
end
