require 'csv'                               # => true
require_relative 'merchant_repository'      # => true
require_relative 'invoice_repository'       # => true
require_relative 'invoice_item_repository'  # => true
require_relative 'item_repository'          # => true
require_relative 'customer_repository'      # => true
require_relative 'transaction_repository'   # => true


class SalesEngine
  attr_reader :parent,
              :customer_repository,
              :invoice_repository,
              :invoice_item_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository
              # :success_transactions_repository

  def initialize
    @parent = self
  end

  def startup
    startup_customer
    startup_invoice
    startup_invoice_item
    startup_item
    startup_merchant
    startup_transaction
  end

  def startup_customer
    customers = CsvReader.load_csv("customers.csv")
    # customers = CsvReader.load_csv("customers_fixture.csv")
    @customer_repository = CustomerRepository.new(customers, parent)
  end

  def startup_invoice
    invoice = CsvReader.load_csv("invoices.csv")
    # invoice = CsvReader.load_csv("invoices_fixture.csv")
    @invoice_repository = InvoiceRepository.new(invoice, parent)
  end

  def startup_invoice_item
    invoice_item = CsvReader.load_csv("invoice_items.csv")
    # invoice_item = CsvReader.load_csv("invoice_items_fixture.csv")
    @invoice_item_repository = InvoiceItemRepository.new(invoice_item, parent)
  end

  def startup_item
    item = CsvReader.load_csv("items.csv")
    # item = CsvReader.load_csv("items_fixture.csv")
    @item_repository = ItemRepository.new(item, parent)
  end

  def startup_merchant
    merchant = CsvReader.load_csv("merchants.csv")
    # merchant = CsvReader.load_csv("merchants_fixture.csv")
    @merchant_repository = MerchantRepository.new(merchant, parent)
  end

  def startup_transaction
    transaction = CsvReader.load_csv("transactions.csv")
    # transaction = CsvReader.load_csv("transactions_fixture.csv")
    @transaction_repository = TransactionRepository.new(transaction, parent)
  end

  def find_invoices_from_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_invoice_items_from_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_items_from_invoice(id)
    items = find_invoice_items_from_invoice(id)
    items.map{|item| find_item_from(item.item_id)}
  end

  def find_transactions_from_customer(id)
    all_invoices = find_invoices_from_customer(id)
    all_invoice_ids = all_invoices.map(&:id)
    all_transactions = all_invoice_ids.map do |invoice_id|
      transaction_repository.find_all_by_invoice_id(invoice_id)
    end
  end

  def find_transactions_from_merchant(id)
    all_invoices = find_invoices_from_merchant(id)
    all_invoice_ids = all_invoices.map(&:id)
    all_transactions = all_invoice_ids.map do |invoice_id|
      transaction_repository.find_all_by_invoice_id(invoice_id)
    end
  end

  def find_successful_transactions(transactions)
    transactions.flatten.select do |transaction|
      transaction unless transaction.result != "success"
    end
  end

  def find_favorite_merchant_from_customer(id)
    all_transactions = find_transactions_from_customer(id)
    successes = find_successful_transactions(all_transactions)
    success_invoice_ids = successes.map(&:invoice_id)
    success_merchant_ids = []
    success_invoice_ids.each do |invoice_id|
      success_merchant_ids << invoice_repository.find_all_by_id(invoice_id).map(&:merchant_id)
    end
    fav_merch = success_merchant_ids.max_by do |id|
       success_merchant_ids.count(id)
     end
    merchant_repository.find_by_merchant_id(fav_merch.first)
  end

  def find_item_from(id)
    item_repository.find_by_item_id(id)
  end

  def find_items_from(id)
    item_repository.find_all_by_item(id)
  end

  def find_invoice_from(id)
    invoice_repository.find_by_id(id)
  end

  def find_customer_from(id)
    customer_repository.find_by_id(id)
  end

  def find_merchant_from(id)
    merchant_repository.find_by_merchant_id(id)
  end

  def find_transaction_from_invoice(id)
     transaction_repository.find_by_invoice_id(id)
  end

  def find_invoice_items_from(item_id)
    invoice_item_repository.find_all_by_item_id(item_id)
  end

  def find_items_from_merchant(id)
    item_repository.find_all_by_merchant_id(id)
  end

  def find_invoices_from_merchant(id)
    invoice_repository.find_all_by_merchant_id(id)
  end

  def find_invoice_from_transaction(id)
    invoice_repository.find_by_id(id)
  end

  def find_revenue_from_merchant(id, date)

    all_invoices = merchant_repository.find_invoices_by_merchant(id)
    if date == 'all'
      invoice_ids = all_invoices.map(&:id)

    else
      invoice_ids = all_invoices.map do |invoice|
        invoice.id unless invoice.created_at != date
      end
    end
    all_transactions = []

    invoice_ids.each do |invoice_id|
      all_transactions << transaction_repository.find_all_by_invoice_id(invoice_id)
    end

    successful_ids = []

    all_transactions.flatten.each do |transaction|
      successful_ids << transaction.invoice_id unless transaction.result != ('success')
    end

    invoice_items = []

    successful_ids.each do |invoice_id|
      invoice_items << invoice_item_repository.find_all_by_invoice_id(invoice_id)
    end
    revenue = 0
    invoice_items.flatten.each do |invoice_item|
        revenue = revenue + invoice_item.unit_price * invoice_item.quantity
    end
    revenue
  end

  def find_favorite_customer_from_merchant(id)
    all_transactions = find_transactions_from_merchant(id)
    successes = find_successful_transactions(all_transactions)
    success_invoice_ids = successes.map(&:invoice_id)
    success_customer_ids = []
    success_invoice_ids.each do |invoice_id|
      success_customer_ids << invoice_repository.find_all_by_id(invoice_id).map(&:customer_id)
    end
    fav_customer = success_customer_ids.max_by do |id|
      success_customer_ids.count(id)
    end
    customer_repository.find_by_id(fav_customer.first)
  end

  def find_pending_customers_from_merchant(id)
    all_transactions = find_transactions_from_merchant(id)
    all_invoice_ids = all_transactions.flatten.map(&:invoice_id)
    successes = find_successful_transactions(all_transactions)
    success_invoice_ids = successes.map(&:invoice_id)
    pending_invoice_ids = all_invoice_ids - success_invoice_ids
    pending_customer_ids = []
    pending_invoice_ids.each do |invoice_id|
      pending_customer_ids << invoice_repository.find_all_by_id(invoice_id).map(&:customer_id)
    end
    pending_customers = []
    pending_customer_ids.each do |customer|
        pending_customers << customer_repository.find_by_id(customer[0])
    end
    pending_customers
  end

  def merchant_revenue(date="all")
    merchant_revenue = []
    merchant_repository.all.each do |merchant|
      merchant_id = merchant.id
      merchant_revenue << [find_revenue_from_merchant(merchant_id, date),merchant_id]
    end
    merchant_revenue
  end

  def find_most_revenue_from_merchant_repository(x)
    merchant_ids = merchant_revenue.sort[-x..-1].collect {|i| i[1]}
    merchants = merchant_ids.map do |merchant_id|
      merchant_repository.find_by_merchant_id(merchant_id)
    end
    merchants.reverse
  end

  def find_revenue_by_date_from_merchant_repository(date)
    merchant_revenue(date).collect {|i| i[0]}.reduce(:+)
  end
end
