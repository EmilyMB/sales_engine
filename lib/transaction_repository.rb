require_relative "transaction"
require_relative "csv_reader"

class TransactionRepository
  attr_reader :merchant, :sales_engine, :transactions

  def initialize(transactions = "", sales_engine)
    @sales_engine = sales_engine
    @transactions ||= transactions.map do |transaction|
      Transaction.new(transaction, self)
    end
    # @transactions ||= transactions.map do |transaction|
    #   # puts "this is transaction class #{transaction.class}"
    #     if transaction.class == Transaction
    #       puts "in if statement"
    #       transaction
    #     else
    #       puts "in else statement"
    #       Transaction.new(transaction, self)
    #     end
    #   end

    # @items = item_data_map do |row|
    #   if is_a?(Item)
    #     row
    #   else
    #     Item.new(row, self)
    #   end
    # end

  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def all
    transactions
  end

  def random
    transactions.sample
  end

  def find_by_id(id)
    transactions.detect { |transaction| transaction.id == id }
  end

  def find_by_invoice_id(id)
    transactions.find do |transaction|
      transaction.invoice_id == id
    end
  end

  def find_by_credit_card_number(card_number)
    transactions.find do |transaction|
      transaction.credit_card_number == card_number
    end
  end

  def find_by_credit_card_expiration(expiration_date)
    transactions.find do |transaction|
      transaction.credit_card_expiration == expiration_date
    end
  end

  def find_by_result(success)
    transactions.detect { |transaction| transaction.result == success }
  end

  def find_all_by_invoice_id(id)
    transactions.select { |transaction| transaction.invoice_id == id }
  end

  def find_all_by_transaction_id(id)
    transactions.select { |transaction| transaction.id == id }
  end

  def find_all_by_credit_card_number(card_number)
    transactions.select do |transaction|
      transaction.credit_card_number == card_number
    end
  end

  def find_all_by_credit_card_expiration(expiration_date)
    transactions.select do |transaction|
      transaction.credit_card_expiration == expiration_date
    end
  end

  def find_all_by_result(success)
    transactions.select { |transaction| transaction.result == success }
  end

  def find_invoice_from(invoice_id)
    sales_engine.find_invoice_from(invoice_id)
  end
end
