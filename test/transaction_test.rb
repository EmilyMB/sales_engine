require_relative 'test_helper'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction, :data, :repository

  def setup
    @data = {
      id: '1',
      invoice_id: '1',
      credit_card_number: '4654405418249632',
      credit_card_expiration: '',
      result: 'success',
      created_at: '2012-03-27 14:54:09 UTC',
      updated_at: '2012-03-27 14:54:09 UTC'
    }
    @repository = Minitest::Mock.new
    @transaction = Transaction.new(data, repository)
  end

  def test_transaction_info
    transaction = Transaction.new(data, repository)
    assert_equal 1, transaction.id
    assert_equal 1, transaction.invoice_id
    assert_equal '4654405418249632', transaction.credit_card_number
    assert_equal '', transaction.credit_card_expiration
    assert_equal 'success', transaction.result
    assert_equal '2012-03-27 14:54:09 UTC', transaction.created_at
    assert_equal '2012-03-27 14:54:09 UTC', transaction.updated_at
  end

  def test_it_delegates_invoice_to_repository
    repository.expect(:find_invoice_from, nil, [1])
    transaction.invoice
    repository.verify
  end
end
