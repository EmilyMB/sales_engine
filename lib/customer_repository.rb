require_relative "customer"
require_relative "office_repository"

class CustomerRepository < OfficeRepository
  attr_reader :sales_engine, :customer_repo

  def initialize(customers, parent)
    @data ||= customers.map { |customer| Customer.new(customer, self) }
    @sales_engine = parent
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def find_by_last_name(criteria)
    generic_find("last_name", criteria)
  end

  def find_by_first_name(criteria)
    generic_find("first_name", criteria)
  end

  def find_all_by_last_name(criteria)
    generic_find_all("last_name", criteria)
  end

  def find_all_by_first_name(criteria)
    generic_find_all("first_name", criteria)
  end

  def find_invoices_from(id)
    sales_engine.find_invoices_from_customer(id)
  end

  def find_transactions_from(id)
    sales_engine.find_transactions_from_customer(id)
  end

  def find_favorite_merchant_from(id)
    sales_engine.find_favorite_merchant_from_customer(id)
  end
end
