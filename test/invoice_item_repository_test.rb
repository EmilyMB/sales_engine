require_relative '../lib/invoice_item_repository'
require_relative 'test_helper'

class InvoiceItemRepoTest < Minitest::Test
  attr_reader :data, :invoice_item_repo, :sales_engine

  def setup
    @data = [{id: 1, item_id: 539, invoice_id: 1, quantity: 5, unit_price: "13635", created_at:"2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"},
      {id: 2, item_id: 528, invoice_id: 1, quantity: 9, unit_price: "23324", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"},
      {id: 3, item_id: 523, invoice_id: 1, quantity: 8, unit_price: "34873", created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"}
    ]
    @sales_engine = Minitest::Mock.new
    @invoice_item_repo = InvoiceItemRepository.new(@data, sales_engine)
  end

  def test_it_has_a_sales_engine
    assert invoice_item_repo
  end

  def test_it_delegates_item_to_sales_engine
    sales_engine.expect(:find_item_from, nil, [539])
    invoice_item_repo.find_item_from(539)
    sales_engine.verify
  end

  def test_it_delegates_invoice_to_sales_engine
    sales_engine.expect(:find_invoice_from, nil, [1])
    invoice_item_repo.find_invoice_from(1)
    sales_engine.verify
  end

  def test_returns_all
    assert_equal data.length, invoice_item_repo.all.length
  end

  def test_random
    assert_equal InvoiceItem, invoice_item_repo.random.class
  end

  def test_find_all_by_id
    invoice_items = invoice_item_repo.find_all_by_id(1)
    invoice_items1 = invoice_item_repo.find_all_by_id(45)
    assert_equal 1, invoice_items.size
    assert_equal 0, invoice_items1.size
  end

  def test_find_all_by_item_id
    invoice_items = invoice_item_repo.find_all_by_item_id(539)
    assert_equal 1, invoice_items.size
  end

  def test_find_all_by_invoice_id
    invoice_items = invoice_item_repo.find_all_by_invoice_id(1)
    assert_equal 3, invoice_items.size
  end

  def test_find_all_by_quantity
    invoice_items = invoice_item_repo.find_all_by_quantity(1)
    invoice_items1 = invoice_item_repo.find_all_by_quantity(5)
    assert_equal 0, invoice_items.size
    assert_equal 1, invoice_items1.size
  end

  def test_find_all_by_unit_price
    invoice_items = invoice_item_repo.find_all_by_unit_price(BigDecimal.new("13635")/100)
    invoice_items1 = invoice_item_repo.find_all_by_unit_price("5")
    assert_equal 1, invoice_items.size
    assert_equal 0, invoice_items1.size
  end

  def test_find_all_by_created_at
    invoice_items = invoice_item_repo.find_all_by_created_at(Date.parse("2012-03-27 14:54:09 UTC"))
    invoice_items1 = invoice_item_repo.find_all_by_created_at(Date.parse("2016-01-01"))
    assert_equal 3, invoice_items.size
    assert_equal 0, invoice_items1.size
  end

  def test_find_all_by_updated_at
    invoice_items = invoice_item_repo.find_all_by_updated_at(Date.parse("2012-03-27 14:54:09 UTC"))
    invoice_items1 = invoice_item_repo.find_all_by_updated_at(Date.parse("2016-01-01"))
    assert_equal 3, invoice_items.size
    assert_equal 0, invoice_items1.size
  end
end
