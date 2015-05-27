require "date"

class Invoice
  attr_reader :id, :customer_id, :merchant_id, :status,
              :created_at, :updated_at, :repo

  def initialize(data, parent)
    @id = data[:id].to_i
    @customer_id = data[:customer_id].to_i
    @merchant_id = data[:merchant_id].to_i
    @status = data[:status]
    @created_at = Date.parse(data[:created_at])
    @updated_at = Date.parse(data[:updated_at])
    @repo = parent
  end

  def transactions
    repo.find_transactions_from(id)
  end

  def invoice_items
    repo.find_invoice_items_from(id)
  end

  def items
    repo.find_items_from(id)
  end

  def customer
    repo.find_customer_from(customer_id)
  end

  def merchant
    repo.find_merchant_from(merchant_id)
  end

  def charge(transaction_info)
    repo.create_transaction_from(id, transaction_info[:credit_card_number],
    transaction_info[:credit_card_expiration], transaction_info[:result])
  end
end
