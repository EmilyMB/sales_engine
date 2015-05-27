require_relative "test_helper"
require_relative "../lib/transaction_repository"

class TransactionRepositoryTest < Minitest::Test
  attr_reader :transaction_repo, :sales_engine

  def setup
    transactions = [
      {
        id: 1,
        invoice_id: 1,
        credit_card_number: "4654405418249632",
        credit_card_expiration: "2012-03-27 14:54:09",
        result: "fail",
        created_at: "2012-03-27 14:54:09 UTC",
        updated_at: "2012-03-27 14:54:09 UTC"
      },
      {
        id: 2,
        invoice_id: 2,
        credit_card_number: "4580251236515201",
        credit_card_expiration: "2012-03-27 14:54:09",
        result: "success",
        created_at: "2012-03-27 14:54:09",
        updated_at: "2012-03-27 14:54:09 UTC"
      },
      {
        id: 3,
        invoice_id: 3,
        credit_card_number: "4354495077693036",
        credit_card_expiration: "2012-03-27 14:54:09",
        result: "success",
        created_at: "2012-03-27 14:54:09 UTC",
        updated_at: "2012-03-27 14:54:09 UTC"
      }
    ]

    @sales_engine = Minitest::Mock.new
    @transaction_repo = TransactionRepository.new(transactions, sales_engine)
  end

  def test_all
    assert_equal 3, transaction_repo.all.size
  end

  def test_random
    assert_equal Transaction, transaction_repo.random.class
  end

  def test_find_by_transaction_id
    transaction = transaction_repo.find_by_id(1)

    assert_equal 1, transaction.id
  end

  def test_find_by_invoice_id
    transaction = transaction_repo.find_by_invoice_id(2)

    assert_equal 2, transaction.invoice_id
  end

  def test_find_by_credit_card_number
    transaction = transaction_repo
      .find_by_credit_card_number("4354495077693036")

    assert_equal "4354495077693036", transaction.credit_card_number
  end

  def test_find_by_credit_card_expiration
    transaction = transaction_repo
      .find_by_credit_card_expiration("2012-03-27 14:54:09")

    assert_equal "2012-03-27 14:54:09", transaction.credit_card_expiration
  end

  def test_find_by_result
    transaction = transaction_repo.find_by_result("success")

    assert_equal "success", transaction.result
  end

  def test_find_all_by_transaction_id
    transactions = transaction_repo.find_all_by_transaction_id(2)
    transactions1 = transaction_repo.find_all_by_transaction_id(3)

    assert_equal 1, transactions.size
    assert_equal 1, transactions1.size
  end

  def test_find_all_by_invoice_id
    transaction = transaction_repo.find_all_by_invoice_id(3)

    assert_equal 1, transaction.size
  end

  def test_find_all_by_credit_card_number
    transactions = transaction_repo.find_all_by_credit_card_number("")
    transactions1 = transaction_repo
      .find_all_by_credit_card_number("4654405418249632")

    assert_equal 0, transactions.size
    assert_equal 1, transactions1.size
  end

  def test_find_all_by_credit_card_expiration
    transactions = transaction_repo
      .find_all_by_credit_card_expiration("2012-03-27 14:54:09")
    transactions1 = transaction_repo.find_all_by_credit_card_expiration("")

    assert_equal 3, transactions.size
    assert_equal 0, transactions1.size
  end

  def test_find_all_by_result
    transactions = transaction_repo.find_all_by_result("success")
    transactions1 = transaction_repo.find_all_by_result("fail")

    assert_equal 2, transactions.size
    assert_equal 1, transactions1.size
  end

  def test_it_delegates_invoice_to_sales_engine
    sales_engine.expect(:find_invoice_from, nil, [3])
    transaction_repo.find_invoice_from(3)
    sales_engine.verify
  end
end
