require_relative "merchant"
require_relative "csv_reader"
require "date"

class MerchantRepository
  attr_reader :merchants, :sales_engine

  def initialize(merchants = "", sales_engine)
    @sales_engine = sales_engine
    @merchants ||= merchants.map { |merchant| Merchant.new(merchant, self) }
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

  def find_favorite_customer_from(id)
    sales_engine.find_favorite_customer_from_merchant(id)
  end

  def find_pending_customers_from(id)
    sales_engine.find_pending_customers_from_merchant(id)
  end

  def most_revenue(x)
    sales_engine.find_most_revenue_from_merchant_repository(x)
  end

  def most_items(x)
    sales_engine.find_most_items_sold_from_merchant_repository(x)
  end

  def revenue(date)
    sales_engine.find_revenue_by_date_from_merchant_repository(date)
  end
end
