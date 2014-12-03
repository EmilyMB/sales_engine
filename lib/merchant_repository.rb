require_relative 'merchant'
require_relative 'csv_reader'

class MerchantRepository
  attr_reader :merchants, :sales_engine  # => nil

  def initialize(merchants = '', sales_engine)
    @sales_engine = sales_engine
    @merchants ||= merchants.map {|merchant| Merchant.new(merchant, self)}
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def all
    merchants
  end

  def random
    merchants.sample
  end

  def find_by_merchant_id(id)
    merchants.find { |merchant| merchant.id == id}
  end

  def find_by_name(name)
    merchants.find { |merchant| merchant.name == name }
  end

  def find_all_by_name(name)
    merchants.find_all { |merchant| merchant.name.downcase == name.downcase }
  end

  def find_all_by_merchant_id(id)
    merchants.find_all { |merchant| merchant.id == id}
  end

  def find_items_by_merchant(id)
    sales_engine.find_items_from_merchant(id)
  end

  def find_invoices_by_merchant(id)
    sales_engine.find_invoices_from_merchant(id)
  end

  def find_revenue_by_merchant(id, date)

    sales_engine.find_revenue_from_merchant(id, date)
  end
end
