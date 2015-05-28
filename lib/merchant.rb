class Merchant
  attr_reader :id, :name, :created_at, :updated_at, :repo

  def initialize(data, repo)
    @id = data[:id].to_i
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repo = repo
  end

  def items
    repo.find_items_by_merchant(id)
  end

  def invoices
    repo.find_invoices_by_merchant(id)
  end

  def revenue(date = "all")
    repo.find_revenue_by_merchant(id, date)
  end

  def favorite_customer
    repo.find_favorite_customer_from(id)
  end

  def customers_with_pending_invoices
    repo.find_pending_customers_from(id)
  end
end
