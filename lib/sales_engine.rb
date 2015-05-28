require "csv"
require_relative "merchant_repository"
require_relative "invoice_repository"
require_relative "invoice_item_repository"
require_relative "item_repository"
require_relative "customer_repository"
require_relative "transaction_repository"
require_relative "startup"

class SalesEngine
  attr_reader :customer_repository,
              :invoice_repository,
              :invoice_item_repository,
              :item_repository,
              :merchant_repository,
              :transaction_repository

  def startup
    @customer_repository = Startup.customers(self)
    @invoice_repository = Startup.invoices(self)
    @invoice_item_repository = Startup.invoice_items(self)
    @item_repository = Startup.items(self)
    @merchant_repository = Startup.merchants(self)
    @transaction_repository = Startup.transactions(self)
  end

  def find_invoices_from_customer(id)
    invoice_repository.find_all_by_customer_id(id)
  end

  def find_invoice_items_from_invoice(id)
    invoice_item_repository.find_all_by_invoice_id(id)
  end

  def find_items_from_invoice(id)
    items = find_invoice_items_from_invoice(id)
    items.map{ |item| find_item_from(item.item_id) }
  end

  def find_transactions_from_customer(id)
    all_invoices = find_invoices_from_customer(id)
    find_transactions_from_invoices(all_invoices)
  end

  def find_transactions_from_merchant(id)
    all_invoices = find_invoices_from_merchant(id)
    find_transactions_from_invoices(all_invoices)
  end

  def find_transactions_from_invoices(invoices)
    all_invoice_ids = invoices.map(&:id)
    all_invoice_ids.map do |invoice_id|
      transaction_repository.find_all_by_invoice_id(invoice_id)
    end
  end

  def find_successful_transactions(transactions)
    transactions.flatten.select do |transaction|
      transaction if transaction.result == "success"
    end
  end

  def find_favorite_merchant_from_customer(id)
    transactions = find_transactions_from_customer(id)
    successes = find_successful_transactions(transactions)
    invoice_ids = successes.map(&:invoice_id)
    merchant_ids = invoice_ids.map do |invoice_id|
       invoice_repository.find_all_by_id(invoice_id).map(&:merchant_id)
    end
    fav_merch = merchant_ids.max_by { |id| merchant_ids.count(id) }
    merchant_repository.find_by_id(fav_merch.first)
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
    merchant_repository.find_by_id(id)
  end

  def find_transactions_from_invoice(id)
     transaction_repository.find_all_by_invoice_id(id)
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

  def find_invoice_ids_by_merchant_and_date(id, date)
    all_invoices = merchant_repository.find_invoices_by_merchant(id)
    if date == "all"
      invoice_ids = all_invoices.map(&:id)
    else
      invoice_ids = all_invoices.map do |invoice|
        invoice.id if invoice.created_at == date
      end
    end
  end

  def find_transactions_from_invoice_ids(invoice_ids)
    invoice_ids.map do |invoice_id|
      transaction_repository.find_all_by_invoice_id(invoice_id)
    end
  end

  def find_invoice_items_from_invoice_ids(invoice_ids)
    invoice_ids.map do |invoice_id|
      invoice_item_repository.find_all_by_invoice_id(invoice_id)
    end
  end

  def find_successful_invoice_items_from_merchant(id, date)
    invoice_ids = find_invoice_ids_by_merchant_and_date(id, date)
    transactions = find_transactions_from_invoice_ids(invoice_ids)
    invoices = find_successful_invoice_ids_from_transactions(transactions)
    find_invoice_items_from_invoice_ids(invoices)
  end

  def find_revenue_from_merchant(id, date)
    revenue = 0
    find_successful_invoice_items_from_merchant(id, date).flatten.each do |invoice_item|
        revenue = revenue + invoice_item.unit_price * invoice_item.quantity
    end
    revenue
  end

  def find_count_items_from_merchant(id, date="all")
    count = find_successful_invoice_items_from_merchant(id, date).flatten.reduce(0) do |count, invoice_item|
       count + invoice_item.quantity
    end
    count
  end

  def find_customer_ids_by_invoices(invoice_ids)
    invoice_ids.map do |invoice_id|
       invoice_repository.find_all_by_id(invoice_id).map(&:customer_id)
    end
  end

  def find_favorite_customer_from_merchant(id)
    transactions = find_transactions_from_merchant(id)
    invoice_ids = find_successful_invoice_ids_from_transactions(transactions)
    customer_ids = find_customer_ids_by_invoices(invoice_ids)
    fav_customer = customer_ids.max_by { |id| customer_ids.count(id) }
    customer_repository.find_by_id(fav_customer.first)
  end

  def find_customers_from_invoice_ids(invoice_ids)
    customer_ids = invoice_ids.map do |invoice_id|
      invoice_repository.find_all_by_id(invoice_id).map(&:customer_id)
    end
    customer_ids.map { |customer| customer_repository.find_by_id(customer[0]) }
  end

  def find_pending_customers_from_merchant(id)
    transactions = find_transactions_from_merchant(id)
    all_invoice_ids = transactions.flatten.map(&:invoice_id)
    invoice_ids = find_successful_invoice_ids_from_transactions(transactions)
    pending_invoice_ids = all_invoice_ids - invoice_ids
    find_customers_from_invoice_ids(pending_invoice_ids)
  end

  def merchant_revenue(date="all")
    merchant_revenue = []
    merchant_repository.all.each do |merchant|
      merchant_id = merchant.id
      merchant_revenue << [find_revenue_from_merchant(merchant_id, date),merchant_id]
    end
    merchant_revenue
  end

  def merchant_items(date="all")
    merchant_items = []
    merchant_repository.all.each do |merchant|
      merchant_id = merchant.id
      merchant_items << [find_count_items_from_merchant(merchant_id, date),merchant_id]
    end
    merchant_items
  end

  def find_most_revenue_from_merchant_repository(x)
    merchant_ids = merchant_revenue.sort[-x..-1].collect { |i| i[1] }
    merchant_ids.reverse.map do |merchant_id|
      merchant_repository.find_by_id(merchant_id)
    end
  end

  def find_most_items_sold_from_merchant_repository(x)
    merchant_ids = merchant_items.sort[-x..-1].collect { |i| i[1] }
    merchant_ids.reverse.map do |merchant_id|
      merchant_repository.find_by_id(merchant_id)
    end
  end

  def find_revenue_by_date_from_merchant_repository(date)
    merchant_revenue(date).collect { |i| i[0] }.reduce(:+)
  end

  def all_transactions
    transaction_repository.all
  end

  def find_successful_invoice_ids_from_transactions(transactions)
    transactions.flatten.map do |transaction|
      transaction.invoice_id if transaction.result == ("success")
    end
  end

  def find_most_revenue_items(x)
    invoice_ids = find_successful_invoice_ids_from_transactions(all_transactions)
    invoice_items = find_invoice_items_from_invoice_ids(invoice_ids)

    items_revenue = invoice_items.flatten.map do |id|
      [id.quantity * id.unit_price,id.item_id ]
    end

    item_hash = items_revenue.group_by{ |n| n[1] }
    item_revenue = []
    for n in 1..10000
      unless item_hash[n].nil?
        item_revenue << [item_hash[n].collect{ |n| n[0] }.reduce(:+), item_hash[n].flatten[1]]
      end
    end

    item_ids = item_revenue.sort[-x..-1].collect { |i| i[1] }
    items = item_ids.map do |item_id|
      item_repository.find_by_item_id(item_id)
    end
    return items.reverse
  end

  def find_most_popular_items(x)
  end
end
