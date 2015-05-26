require_relative '../lib/customer_repository'
require_relative 'test_helper'

class CustomerRespositoryTest < Minitest::Test
  attr_reader :sales_engine, :customer_repo, :data

  def setup
    @data = [{id: 45, first_name: "bob", last_name: "jones", created_at: "2010-01-01", updated_at: "2014-01-01" },
      {id: 46, first_name: "jane", last_name: "Jones", created_at: "2012-01-01", updated_at: "2015-01-01" },
      {id: 47, first_name: "may", last_name: "johnson", created_at: "2011-01-01", updated_at: "2014-01-01" }]
    @sales_engine = Minitest::Mock.new
    @customer_repo = CustomerRepository.new(data, sales_engine)
  end

  def test_it_has_a_sales_engine
    assert customer_repo
  end

  def test_it_delegates_invoices_to_sales_engine
    sales_engine.expect(:find_invoices_from_customer, nil, [45])
    customer_repo.find_invoices_from(45)
    sales_engine.verify
  end

  def test_it_delegates_transactions_to_sales_engine
    sales_engine.expect(:find_transactions_from_customer, nil, [45])
    customer_repo.find_transactions_from(45)
    sales_engine.verify
  end

  def test_it_delegates_favorite_merchant_to_sales_engine
    sales_engine.expect(:find_favorite_merchant_from_customer, nil, [45])
    customer_repo.find_favorite_merchant_from(45)
  end

  def test_returns_all
    assert_equal data.length, customer_repo.all.length
  end

  def test_random
    assert_equal Customer, customer_repo.random.class
  end

  def test_find_all_by_last_name
    customers = customer_repo.find_all_by_last_name("jones")
    assert_equal 2, customers.size
  end

  def test_find_all_by_last_name_with_uppercase
    customers = customer_repo.find_all_by_last_name("JONES")
    assert_equal 2, customers.size
  end

  def test_find_all_by_first_name
    customers = customer_repo.find_all_by_first_name("jones")
    assert_equal 0, customers.size
  end

  def test_find_all_by_id
    customers = customer_repo.find_all_by_id(25)
    customers1 = customer_repo.find_all_by_id(45)
    assert_equal 0, customers.size
    assert_equal 1, customers1.size
  end

  def test_find_all_by_created_at
    customers = customer_repo.find_all_by_created_at("2010-01-01")
    customers1 = customer_repo.find_all_by_created_at("2016-01-01")
    assert_equal 1, customers.size
    assert_equal 0, customers1.size
  end

  def test_find_all_by_updated_at
    customers = customer_repo.find_all_by_updated_at("2014-01-01")
    customers1 = customer_repo.find_all_by_updated_at("2016-01-01")
    assert_equal 2, customers.size
    assert_equal 0, customers1.size
  end
end
