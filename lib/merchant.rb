class Merchant
  attr_reader :id, :name, :created_at, :updated_at, :repository

  def initialize(data, repository)
    @id = data[:id].to_i
    @name = data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repository = repository
  end

  def items
    repository.find_items_by_merchant(id)
  end

  def invoices
    repository.find_invoices_by_merchant(id)
  end

  def revenue(date = "all")
    repository.find_revenue_by_merchant(id, date)
  end

  def favorite_customer
    repository.find_favorite_customer_from(id)
  end

  def customers_with_pending_invoices
    repository.find_pending_customers_from(id)
  end
end
