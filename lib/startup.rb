module Startup
  def self.customers(parent)
    customers = CsvReader.load_csv("customers.csv")
    CustomerRepository.new(customers, parent)
  end

  def self.invoices(parent)
    invoice = CsvReader.load_csv("invoices.csv")
    InvoiceRepository.new(invoice, parent)
  end

  def self.invoice_items(parent)
    invoice_item = CsvReader.load_csv("invoice_items.csv")
    InvoiceItemRepository.new(invoice_item, parent)
  end

  def self.items(parent)
    item = CsvReader.load_csv("items.csv")
    ItemRepository.new(item, parent)
  end

  def self.merchants(parent)
    merchant = CsvReader.load_csv("merchants.csv")
    MerchantRepository.new(merchant, parent)
  end

  def self.transactions(parent)
    transaction = CsvReader.load_csv("transactions.csv")
    TransactionRepository.new(transaction, parent)
  end
end
