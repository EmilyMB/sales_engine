require_relative "../lib/invoice_repository"
require_relative "test_helper"

class InvoiceRepoTest < Minitest::Test
  attr_reader :invoice_repo, :sales_engine

  def setup
    data = [
      {
        id: 1,
        customer_id: 539,
        merchant_id: 1,
        status: "shipped",
        created_at: "2012-03-27 14:54:09 UTC",
        updated_at: "2012-03-27 14:54:09 UTC"
      },
      {
        id: 2,
        customer_id: 528,
        merchant_id: 1,
        status: "shipped",
        created_at: "2012-03-27 14:54:09 UTC",
        updated_at: "2012-03-27 14:54:09 UTC"
      },
      {
        id: 3,
        customer_id: 523,
        merchant_id: 1,
        status: "shipped",
        created_at: "2012-03-27 14:54:09 UTC",
        updated_at: "2012-03-27 14:54:09 UTC"
      }
    ]
    @sales_engine = Minitest::Mock.new
    @invoice_repo = InvoiceRepository.new(data, sales_engine)
  end

  def test_it_exists
    assert invoice_repo
  end

  def test_it_delegates_customer_to_sales_engine
    sales_engine.expect(:find_customer_from, nil, [539])
    invoice_repo.find_customer_from(539)
    sales_engine.verify
  end

  def test_it_delegates_invoice_items_to_sales_engine
    sales_engine.expect(:find_invoice_items_from_invoice, nil, [1])
    invoice_repo.find_invoice_items_from(1)
    sales_engine.verify
  end

  def test_it_delegates_items_to_sales_engine
    sales_engine.expect(:find_items_from_invoice, nil, [1])
    invoice_repo.find_items_from(1)
    sales_engine.verify
  end

  def test_it_delegates_create_transaction_to_sales_engine
    sales_engine.expect(:create_transaction_from_invoice,
      nil,
      [
        1,
        credit_card_number: "4444333322221111",
        credit_card_expiration: "10/13",
        result: "success"
      ]
    )
    invoice_repo.create_transaction_from(1,
      credit_card_number: "4444333322221111",
      credit_card_expiration: "10/13",
      result: "success"
    )
    sales_engine.verify
  end

  def test_returns_all
    assert_equal 3, invoice_repo.all.length
  end

  def test_random
    assert_equal Invoice, invoice_repo.random.class
  end

  def test_find_all_by_id
    invoices = invoice_repo.find_all_by_id(1)
    invoices1 = invoice_repo.find_all_by_id(45)

    assert_equal 1, invoices.size
    assert_equal 0, invoices1.size
  end

  def test_find_all_by_merchant_id
    invoices = invoice_repo.find_all_by_merchant_id(1)

    assert_equal 3, invoices.size
  end

  def test_find_all_by_customer_id
    invoices = invoice_repo.find_all_by_customer_id(539)

    assert_equal 1, invoices.size
  end

  def test_find_all_by_status
    invoices = invoice_repo.find_all_by_status("shipped")
    invoices1 = invoice_repo.find_all_by_status("not shipped")

    assert_equal 3, invoices.size
    assert_equal 0, invoices1.size
  end

  def test_find_all_by_created_at
    found_date = Date.parse("2012-03-27 14:54:09 UTC")
    not_found_date = Date.parse("2016-01-01")

    invoices = invoice_repo.find_all_by_created_at(found_date)
    invoices1 = invoice_repo.find_all_by_created_at(not_found_date)

    assert_equal 3, invoices.size
    assert_equal 0, invoices1.size
  end

  def test_find_all_by_updated_at
    found_date = Date.parse("2012-03-27 14:54:09 UTC")
    not_found_date = Date.parse("2016-01-01")

    invoices = invoice_repo.find_all_by_updated_at(found_date)
    invoices1 = invoice_repo.find_all_by_updated_at(not_found_date)

    assert_equal 3, invoices.size
    assert_equal 0, invoices1.size
  end

  def test_create_standardizes_input_for_invoice
    input = {
      customer: "customer",
      merchant: "merchant",
      status: "shipped",
      items: ["item1", "item2", "item3"]
    }

    sales_engine.expect(:create_invoice_items_from_inputs_and_invoice, nil, [4, input])
  end

  def test_it_delegates_create_invoice_items_to_sales_engine
    input = {
      customer: "customer",
      merchant: "merchant",
      status: "shipped",
      items: ["item1", "item2", "item3"]
    }

    sales_engine.expect(:create_invoice_items_from_inputs_and_invoice, nil, [4,input])
    invoice_repo.create_invoice_items_from(4, input)
    sales_engine.verify
  end
end
