require_relative "test_helper"
require_relative "../lib/item"

class ItemTest < Minitest::Test
  attr_reader :item, :data, :repository

  def test_item_exists
  end

  def setup
    @data = {
      id: "4",
      name: "Nemo Facere",
      description: "Sunt eum id eius magni consequuntur delectus veritatis.",
      unit_price: "4291",
      merchant_id: "1",
      created_at: "2012-03-27 14:53:59 UTC",
      updated_at: "2012-03-27 14:53:59 UTC"
    }
    @repository = Minitest::Mock.new
    @item = Item.new(data, repository)

  end

  def test_item_info
    assert_equal 4, item.id
    assert_equal "Nemo Facere", item.name
    assert_equal "Sunt eum id eius magni consequuntur delectus veritatis.",  item.description
    assert_equal BigDecimal.new("4291")/100, item.unit_price
    assert_equal 1, item.merchant_id
    assert_equal "2012-03-27 14:53:59 UTC", item.created_at
    assert_equal "2012-03-27 14:53:59 UTC", item.updated_at
  end

  def test_it_delegates_merchant_to_repository
    repository.expect(:find_merchant_from, nil, [1])
    item.merchant
    repository.verify
  end

  def test_it_delegates_invoice_items_to_repository
    repository.expect(:find_invoice_items_from, nil, [4])
    item.invoice_items
    repository.verify
  end
end
