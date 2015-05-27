require_relative "../lib/invoice"
require_relative "test_helper"

class InvoiceTest < Minitest::Test
  attr_reader :parent, :invoice

  def setup
    data = {
      id: 45,
      customer_id: 34696,
      merchant_id: 955,
      status: "valid",
      created_at: "2010-01-01",
      updated_at: "2015-01-01"
    }
    @parent = Minitest::Mock.new
    @invoice = Invoice.new(data, parent)
  end

  def test_invoice_attributes
    assert_equal 45, invoice.id
    assert_equal 34696, invoice.customer_id
    assert_equal 955, invoice.merchant_id
    assert_equal "valid", invoice.status
    assert_equal Date.parse("2010-01-01"), invoice.created_at
    assert_equal Date.parse("2015-01-01"), invoice.updated_at
  end

  def test_it_has_a_transactions_method
    assert invoice.respond_to?(:transactions)
  end

  def test_delegates_transactions_to_parent_repo
    parent.expect(:find_transactions_from, nil, [45])
    invoice.transactions
    parent.verify
  end

  def test_delegates_invoice_items_to_parent_repo
    parent.expect(:find_invoice_items_from, nil, [45])
    invoice.invoice_items
    parent.verify
  end

  def test_delegates_items_to_parent_repo
    parent.expect(:find_items_from, nil, [45])
    invoice.items
    parent.verify
  end

  def test_delegates_customer_to_parent_repo
    parent.expect(:find_customer_from, nil, [34696])
    invoice.customer
    parent.verify
  end

  def test_delegates_merchant_to_parent_repo
    parent.expect(:find_merchant_from, nil, [955])
    invoice.merchant
    parent.verify
  end

  def test_delegates_charge_to_parent_repo
    parent.expect(:create_transaction_from,
                  nil,
                  [45, "4444333322221111", "10/13",  "success"]
                 )
    invoice.charge(credit_card_number: "4444333322221111",
                   credit_card_expiration: "10/13",
                   result: "success"
                  )
    parent.verify
  end
end
