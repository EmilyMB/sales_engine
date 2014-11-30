require 'csv'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'


class SalesEngine
  attr_reader :parent, :customer_repository, :invoice_repository,
              :invoice_item_repository, :item_repository, :merchant_repository,
              :transaction_repository


  def initialize
    @parent = self
  end

  def startup
    startup_customer
    startup_invoice
    startup_invoice_item
    startup_item
    startup_merchant
    # startup_transaction
  end

  def startup_customer
    customers = CsvReader.load_csv("customers_fixer.rb")
    @customer_repository = CustomerRepository.new(customers, parent)
  end

  def startup_invoice
    invoice = CsvReader.load_csv("invoices_fixer.rb")
    @invoice_repository = InvoiceRepository.new(invoice, parent)
  end

  def startup_invoice_item
    invoice_item = CsvReader.load_csv("invoice_items_fixer.rb")
    @invoice_item_repository = InvoiceItemRepository.new(invoice_item, parent)
  end

  def startup_item
    item = CsvReader.load_csv("items_fixer.rb")
    @item_repository = ItemRepository.new(item, parent)
  end

  def startup_merchant
    merchant = CsvReader.load_csv("merchants_fixer.rb")
    @merchant_repository = MerchantRepository.new(merchant, parent)
  end
  #
  # def startup_transaction
  #   transaction = CsvReader.load_csv("transactions_fixer.rb")
  #   @transaction_repository = TransactionRepository.new(transaction, parent)
  # end

  def find_invoices_from_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_transactions_from_customer(id)
    all_invoices = find_invoices_from_customer(id)
    all_invoice_ids = all_invoices.map(&:id)
    # all_transactions = all_invoice_ids.map {|invoice_id| transaction_repository.select {|transaction| transaction.invoice_id == invoice_id }
    # }
    # all_invoice_ids.each do |invoice_id|
    #   all transactions << transaction_repository.select {|transaction| transaction.invoice_id == invoice_id }
    # end
  end

  def find_favorite_merchant_from_customer(id)
    successes = find_transactions_from_customer(id).select{|transaction| transaction.result == "success"}
    success_invoice_ids = successes.map(&:invoice_id)
    success_merchant_ids = []
    success_invoice_ids.each do |invoice_id|
      success_merchant_id << invoice_repository.merchant_id unless invoice_repository.id != invoice_id
    end
    fav_merch = success_merch_id.max_by{|id| success_merch_id.count(id) }
    merchant_repository.find_by_merchant_id(fav_merch)
  end
end
