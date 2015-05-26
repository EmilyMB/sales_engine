require_relative "invoice"
require_relative "office_repository"

class InvoiceRepository < OfficeRepository
  attr_reader :data, :sales_engine

  def initialize(invoice, parent)
    @data ||= invoice.map {|invoice| Invoice.new(invoice, self)}
    @sales_engine = parent
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def find_by_customer_id(criteria)
    generic_non_string_find("customer_id", criteria)
  end

  def find_by_merchant_id(criteria)
    generic_non_string_find("merchant_id", criteria)
  end

  def find_by_status(criteria)
    generic_find("status", criteria)
  end

  def find_all_by_customer_id(criteria)
    generic_non_string_find_all("customer_id", criteria)
  end

  def find_all_by_merchant_id(criteria)
    generic_non_string_find_all("merchant_id", criteria)
  end

  def find_all_by_status(criteria)
    generic_find_all("status", criteria)
  end

  def find_customer_from(id)
    sales_engine.find_customer_from(id)
  end

  def find_invoice_items_from(id)
    sales_engine.find_invoice_items_from_invoice(id)
  end

  def find_items_from(id)
    sales_engine.find_items_from_invoice(id)
  end

  def find_merchant_from(id)
    sales_engine.find_merchant_from(id)
  end

  def find_transactions_from(id)
    sales_engine.find_transactions_from_invoice(id)
  end

  def create_transaction_from(id, transaction_info)
    sales_engine.create_transaction_from_invoice(id, transaction_info)
  end

  def create(input)
    invoice = Hash.new{}
    invoice[:id] = data.max_by(&:id).id + 1
    invoice[:customer_id] = data.max_by(&:customer_id).customer_id + 1
    invoice[:merchant_id] = data.max_by(&:merchant_id).merchant_id + 1
    # invoice[:created_at] = Time.now()
    # invoice[:updated_at] = Time.now()
    create_invoice_items_from(invoice[:id], input)
    Invoice.new(invoice, self)
  end

  def create_invoice_items_from(id, input)
    sales_engine.create_invoice_items_from_inputs_and_invoice(id, input)
  end
end
