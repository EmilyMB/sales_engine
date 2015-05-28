require_relative "test_helper"
require_relative "../lib/sales_engine"

class SalesEngineTest < Minitest::Test
  attr_reader :sales_engine

  def sales_engine
    @sales_engine ||= SalesEngine.new
  end

  def test_response_to_startup
    assert sales_engine.respond_to?(:startup)
  end

  def test_a_sales_engine_has_repositories
    sales_engine.startup

    assert sales_engine.customer_repository
    assert sales_engine.invoice_repository
    assert sales_engine.invoice_item_repository
    assert sales_engine.item_repository
    assert sales_engine.merchant_repository
    assert sales_engine.transaction_repository
  end

  def test_it_finds_invoices_from_customer_id
    assert sales_engine.respond_to?(:find_invoices_from_customer)
  end

  def test_it_finds_transactions_from_customer_id
    assert sales_engine.respond_to?(:find_transactions_from_customer)
  end

  def test_it_finds_favorite_merchant_from_customer_id
    assert sales_engine.respond_to?(:find_favorite_merchant_from_customer)
  end

  def test_it_finds_item_from_item_id
    assert sales_engine.respond_to?(:find_item_from)
  end

  def test_it_finds_invoice_from_invoice_id
    assert sales_engine.respond_to?(:find_invoice_from)
  end

  def test_it_finds_customer_from_customer_id
    assert sales_engine.respond_to?(:find_customer_from)
  end

  def test_it_finds_merchant_from_merchant_id
    assert sales_engine.respond_to?(:find_merchant_from)
  end

  def test_it_finds_transactions_from_invoice_id
    assert sales_engine.respond_to?(:find_transactions_from_invoice)
  end

  def test_it_finds_invoice_items_from_item_id
    assert sales_engine.respond_to?(:find_invoice_items_from)
  end

  def test_it_finds_items_from_merchant_id
    assert sales_engine.respond_to?(:find_items_from_merchant)
  end

  def test_it_finds_invoices_from_merchant
    assert sales_engine.respond_to?(:find_invoices_from_merchant)
  end

  def test_it_finds_invoice_from_transaction
    assert sales_engine.respond_to?(:find_invoice_from_transaction)
  end

  def test_it_finds_revenue_from_merchant
    assert sales_engine.respond_to?(:find_revenue_from_merchant)
  end

  def test_it_finds_favorite_customer_from_merchant
    assert sales_engine.respond_to?(:find_favorite_customer_from_merchant)
  end

  def test_it_finds_pending_customers_from_merchant
    assert sales_engine.respond_to?(:find_pending_customers_from_merchant)
  end

  def test_it_finds_most_revenue
    assert sales_engine.respond_to?(:find_most_revenue_from_merchant_repository)
  end

  def test_it_finds_most_items_from_merchant_repo
    assert sales_engine.respond_to?(:find_most_items_sold_from_merchant_repository)
  end

  def test_it_finds_revenue_by_date
    assert sales_engine.respond_to?(:find_revenue_by_date_from_merchant_repository)
  end

  def test_it_finds_highest_revenue_items
    assert sales_engine.respond_to?(:find_most_revenue_items)
  end

  def test_it_find_most_sold_items
    assert sales_engine.respond_to?(:find_most_popular_items)
  end
end
