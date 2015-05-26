require_relative '../lib/customer'
require_relative 'test_helper'

class CustomerTest < Minitest::Test
  attr_reader :data, :customer, :parent

  def setup
    @data = {
      id: 45,
      first_name: "bob",
      last_name: "jones",
      created_at: "2010-01-01",
      updated_at: "2014-01-01"
    }
    @parent = Minitest::Mock.new
    @customer = Customer.new(data, @parent)
  end

  def test_customer_attributes
    assert_equal 45, customer.id
    assert_equal 'bob', customer.first_name
    assert_equal 'jones', customer.last_name
    assert_equal "2010-01-01", customer.created_at
    assert_equal "2014-01-01", customer.updated_at
  end

  def test_it_delegates_invoices_to_parent
    parent.expect(:find_invoices_from, nil, [45])
    customer.invoices
    parent.verify
  end

  def test_it_delegates_transactions_to_parent
    parent.expect(:find_transactions_from, nil, [45])
    customer.transactions
    parent.verify
  end

  def test_it_delegates_favorite_merchant_to_parent
    parent.expect(:find_favorite_merchant_from, nil, [45])
    customer.favorite_merchant
    parent.verify
  end
end

# invoices returns a collection of Invoice instances associated with this object.
#transactions returns an array of Transaction instances associated with the customer
#favorite_merchant returns an instance of Merchant where the customer has conducted the most successful transactions
