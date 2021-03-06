class Customer
  attr_reader :id, :first_name, :last_name, :created_at, :updated_at, :repo

  def initialize(data, repo)
    @id = data[:id].to_i
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repo = repo
  end

  def invoices
    repo.find_invoices_from(id)
  end

  def transactions
    repo.find_transactions_from(id)
  end

  def favorite_merchant
    repo.find_favorite_merchant_from(id)
  end
end
