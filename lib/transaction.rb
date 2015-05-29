class Transaction
  attr_reader :id, :invoice_id, :credit_card_number, :credit_card_expiration,
              :result, :created_at, :updated_at, :repo

  def initialize(data, repo)
    @id = data[:id].to_i
    @invoice_id = data[:invoice_id].to_i
    @credit_card_number = data[:credit_card_number]
    @credit_card_expiration = data[:credit_card_expiration]
    @result = data[:result]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repo = repo
  end

  def invoice
    repo.find_invoice_from(invoice_id)
  end
end
