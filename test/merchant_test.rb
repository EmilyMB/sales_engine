require_relative "test_helper"
require_relative "../lib/merchant"

class MerchantTest < Minitest::Test
  attr_reader :merchant, :repo

  def setup
    data = {
      id: "3",
      name: "Willms and Sons",
      created_at: "2012-03-27 14:53:59 UTC",
      updated_at: "2012-03-27 14:53:59 UTC"
    }
    @repo = Minitest::Mock.new
    @merchant = Merchant.new(data, repo)
  end

  def test_merchant_info
    assert_equal 3, merchant.id
    assert_equal "Willms and Sons", merchant.name
    assert_equal "2012-03-27 14:53:59 UTC", merchant.created_at
    assert_equal "2012-03-27 14:53:59 UTC", merchant.updated_at
  end

  def test_it_has_a_repo
    assert merchant.repo
  end

  def test_it_delegates_items_method_to_repo
    repo.expect(:find_items_by_merchant, nil, [3])
    merchant.items
    repo.verify
  end

  def test_find_it_delegates_invoices_by_merchant
    repo.expect(:find_invoices_by_merchant, nil, [3])
    merchant.invoices
    repo.verify
  end

  def test_it_delagates_revenue_to_repo
    repo.expect(:find_revenue_by_merchant, nil, [3, "all"])
    merchant.revenue
    repo.verify
  end

  def test_it_delegates_favorite_customer_to_repo
    repo.expect(:find_favorite_customer_from, nil, [3])
    merchant.favorite_customer
    repo.verify
  end

  def test_it_delegates_pending_customers_to_repo
    repo.expect(:find_pending_customers_from, nil, [3])
    merchant.customers_with_pending_invoices
    repo.verify
  end
end
