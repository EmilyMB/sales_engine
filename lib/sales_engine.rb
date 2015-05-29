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
    items.map { |item| find_item_from(item.item_id) }
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
    invoice_ids = invoices.map(&:id)
    invoice_ids.map { |id| transaction_repository.find_all_by_invoice_id(id) }
  end

  def find_successful_transactions(transactions = transaction_repository.all)
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
    fav_merch = merchant_ids.max_by { |merch_id| merchant_ids.count(merch_id) }
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

  def find_merchants_from(merchant_ids)
    merchant_ids.map { |id| merchant_repository.find_by_id(id) }
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
    invoices = merchant_repository.find_invoices_by_merchant(id)
    if date == "all"
      invoices.map(&:id)
    else
      invoices.map { |invoice| invoice.id if invoice.created_at == date }
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
    invoices = find_successful_invoice_ids_from_trans(transactions)
    find_invoice_items_from_invoice_ids(invoices).flatten
  end

  def find_revenue_from_merchant(id, date)
    invoice_items = find_successful_invoice_items_from_merchant(id, date)
    invoice_items.inject(0) do |revenue, item|
      revenue + item.unit_price * item.quantity
    end
  end

  def find_count_items_from_merchant(id, date="all")
    invoice_items = find_successful_invoice_items_from_merchant(id, date)
    invoice_items.inject(0) do |count, invoice_item|
       count + invoice_item.quantity
    end
  end

  def find_customer_ids_by_invoices(invoice_ids)
    invoice_ids.map do |invoice_id|
       invoice_repository.find_all_by_id(invoice_id).map(&:customer_id)
    end
  end

  def find_favorite_customer_from_merchant(id)
    transactions = find_transactions_from_merchant(id)
    invoice_ids = find_successful_invoice_ids_from_trans(transactions)
    customer_ids = find_customer_ids_by_invoices(invoice_ids).flatten
    fav_customer = customer_ids.max_by { |cust_id| customer_ids.count(cust_id) }
    customer_repository.find_by_id(fav_customer)
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
    invoice_ids = find_successful_invoice_ids_from_trans(transactions)
    pending_invoice_ids = all_invoice_ids - invoice_ids
    find_customers_from_invoice_ids(pending_invoice_ids)
  end

  def merchant_revenue(date="all")
    merchant_repository.all.map do |merchant|
      [find_revenue_from_merchant(merchant.id, date), merchant.id]
    end
  end

  def merchant_items(date="all")
    merchant_repository.all.map do |merchant|
      [find_count_items_from_merchant(merchant.id, date), merchant.id]
    end
  end

  def find_most_revenue_from_merchant_repo(x)
    merchant_ids = merchant_revenue.sort[-x..-1].map { |i| i[1] }.reverse
    find_merchants_from(merchant_ids)
  end

  def find_most_items_sold_from_merchant_repo(x)
    merchant_ids = merchant_items.sort[-x..-1].map { |i| i[1] }.reverse
    find_merchants_from(merchant_ids)
  end

  def find_revenue_by_date_from_merchant_repo(date)
    merchant_revenue(date).map { |i| i[0] }.inject(:+)
  end

  def find_successful_invoice_ids_from_trans(trans = transaction_repository.all)
    trans.flatten.map do |transaction|
      transaction.invoice_id if transaction.result == ("success")
    end
  end

  def items_with_revenue
    invoice_ids = find_successful_invoice_ids_from_trans
    invoice_items = find_invoice_items_from_invoice_ids(invoice_ids).flatten
    invoice_items.inject(Hash.new(0)) do |hsh, id|
      hsh[id.item_id] += id.quantity * id.unit_price; hsh
    end
  end

  def find_most_revenue_items(x)
    items_sorted_desc(items_with_revenue, x)
  end

  def items_with_count
    invoice_ids = find_successful_invoice_ids_from_trans
    invoice_items = find_invoice_items_from_invoice_ids(invoice_ids).flatten
    invoice_items.inject(Hash.new(0)) do |hsh, id|
      hsh[id.item_id] += id.quantity; hsh
    end
  end

  def find_most_popular_items(x)
    items_sorted_desc(items_with_count, x)
  end

  def items_sorted_desc(items, x)
    item_ids = items.sort_by { |_key, val| -val }.map { |i| i[0] }
    item_ids[0...x].map do |item_id|
      item_repository.find_by_item_id(item_id)
    end
  end

  def find_best_day_for(item_id)
    items = invoice_items_with_dates_for(item_id)
    total = items.inject(Hash.new(0)) do |hsh, item|
      hsh[item[1]] += item[0].quantity; hsh
    end
    total.max_by { |_key, val| val }[0]
  end

  def invoice_items_with_dates_for(item_id)
    invoice_items = find_invoice_items_from(item_id)
    invoice_ids = invoice_items.map(&:invoice_id)
    invoices = invoice_ids.map { |id| invoice_repository.find_by_id(id) }
    invoice_dates = invoices.map(&:created_at)
    invoice_items.zip(invoice_dates)
  end
end
