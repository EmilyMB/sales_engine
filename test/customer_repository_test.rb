require_relative '../lib/customer_repository'
require_relative 'test_helper'

class CustomerRespositoryTest < Minitest::Test

  def setup
    @data = [{id: 45, first_name: "bob", last_name: "jones", created_at: "2010-01-01", updated_at: "2014-01-01" },
      {id: 46, first_name: "jane", last_name: "Jones", created_at: "2012-01-01", updated_at: "2015-01-01" },
      {id: 47, first_name: "may", last_name: "johnson", created_at: "2011-01-01", updated_at: "2014-01-01" }]
    @customer_repo = CustomerRepository.new(@data)
  end

  def test_returns_all
    assert_equal @data.length, @customer_repo.all.length
  end

  def test_random
    assert_equal Customer, @customer_repo.random.class
  end

  def test_find_by_last_name
    customers = @customer_repo.find_by_last_name("jones")
    assert_equal 2, customers.size
  end

  def test_find_by_last_name_with_uppercase
    customers = @customer_repo.find_by_last_name("JONES")
    assert_equal 2, customers.size
  end

  def test_find_by_first_name
    customers = @customer_repo.find_by_first_name("jones")
    assert_equal 0, customers.size
  end

  def test_find_by_id
    customers = @customer_repo.find_by_id(25)
    customers1 = @customer_repo.find_by_id(45)
    assert_equal 0, customers.size
    assert_equal 1, customers1.size
  end

  def test_find_by_created_at
    customers = @customer_repo.find_by_created_at("2010-01-01")
    customers1 = @customer_repo.find_by_created_at("2016-01-01")
    assert_equal 1, customers.size
    assert_equal 0, customers1.size
  end

  def test_find_by_updated_at
    customers = @customer_repo.find_by_updated_at("2014-01-01")
    customers1 = @customer_repo.find_by_updated_at("2016-01-01")
    assert_equal 2, customers.size
    assert_equal 0, customers1.size
  end
end
