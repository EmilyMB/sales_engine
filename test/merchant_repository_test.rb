require_relative 'test_helper'
require_relative '../lib/merchant_repository'

class MerchantRepositoryTest < Minitest::Test
attr_reader :merchants, :merchant_repository, :sales_engine

def setup
  @merchants = [{
      id: 3,
      name: 'Willms and Sons',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 14:53:59 UTC'
    },
    {
      id: 2,
      name: 'Klein, Rempel and Jones',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 14:53:59 UTC'
    },
    {
      id: 7,
      name: 'Bernhard-Johns',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 14:53:59 UTC'
    }
    ]

    @sales_engine = Minitest::Mock.new
    @merchant_repository = MerchantRepository.new(merchants, sales_engine)
  end

  def test_all
    assert_equal 3, merchant_repository.all.size
  end

  def test_random
    assert_class = Merchant, merchant_repository.random
  end

  def test_find_by_merchant_id
    merchant = merchant_repository.find_by_merchant_id(7)
    assert_equal 7, merchant.id
  end

  def test_find_by_name
    merchant = merchant_repository.find_by_name('Bernhard-Johns')
    assert_equal 'Bernhard-Johns', merchant.name
  end

  def test_find_all_by_merchant_id
    merchant = merchant_repository.find_all_by_merchant_id(2)
    merchant1 = merchant_repository.find_all_by_merchant_id(7)
    assert_equal 1, merchant.size
    assert_equal 1, merchant1.size
  end

  def test_find_all_by_name
    merchant = merchant_repository.find_all_by_name('Bernhard-Johns')
    merchant1 = merchant_repository.find_all_by_name('Klein, Rempel and Jones')
    assert_equal 1, merchant.size
    assert_equal 1, merchant1.size
  end

  def test_it_delegates_items_to_sales_engine
    sales_engine.expect(:find_items_from_merchant, nil, [7])
    merchant_repository.find_items_by_merchant(7)
    sales_engine.verify
  end

  def test_it_delegates_invoices_to_sales_engine
    sales_engine.expect(:find_invoices_from_merchant, nil, [7])
    merchant_repository.find_invoices_by_merchant(7)
    sales_engine.verify
  end

  def test_it_delegates_revenue_to_sales_engine
    sales_engine.expect(:find_revenue_from_merchant, nil, [2, 'all'])
    merchant_repository.find_revenue_by_merchant(2, 'all')
    sales_engine.verify
  end

  def test_it_delegates_favorite_customer_to_sales_engine
    sales_engine.expect(:find_favorite_customer_from_merchant, nil, [3])
    merchant_repository.find_favorite_customer_from(3)
    sales_engine.verify
  end
end
