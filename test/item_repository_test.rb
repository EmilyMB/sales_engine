require_relative "test_helper"
require_relative "../lib/item_repository"

class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repository, :sales_engine

  def setup
    items = [
      {
        id: 3,
        name: "Item",
        description: "Ea Voluptatum,Sunt officia eum qui molestiae.",
        unit_price: "67076",
        merchant_id: 1,
        created_at: "2012-03-27 14:53:59 UTC",
        updated_at: "2012-03-27 14:53:59 UTC"
      },
      {
        id: 2,
        name: "Item",
        description: "Autem Minima,Cumque consequuntur ad.",
        unit_price: "67076",
        merchant_id: 1,
        created_at: "2012-03-27 14:53:59 UTC",
        updated_at: "2012-03-27 14:53:59 UTC"
      },
      {
        id: 7,
        name: "Item",
        description: "Expedita Fuga,Fuga assumenda occaecati hi.",
        unit_price: "31163",
        merchant_id: 1,
        created_at: "2012-03-27 14:53:59 UTC",
        updated_at: "2012-03-27 14:53:59 UTC"
      }
    ]

    @sales_engine = Minitest::Mock.new
    @item_repository = ItemRepository.new(items, sales_engine)
  end

  def test_all
    assert_equal 3, item_repository.all.size
  end

  def test_random
    assert_equal Item, item_repository.random.class
  end

  def test_find_by_item_id
    item = item_repository.find_by_item_id(7)

    assert_equal 7, item.id
  end

  def test_find_by_name
    item = item_repository.find_by_name("Item")

    assert_equal "Item", item.name
  end

  def test_find_by_item_description
    item = item_repository
      .find_by_item_description("Autem Minima,Cumque consequuntur ad.")

    assert_equal "Autem Minima,Cumque consequuntur ad.", item.description
  end

  def test_find_by_unit_price
    price = BigDecimal.new("31163") / 100

    item = item_repository.find_by_unit_price(price)

    assert_equal price, item.unit_price
  end

  def test_find_by_merchant_id
     item = item_repository.find_by_merchant_id(1)

     assert_equal 1, item.merchant_id
  end

  def test_find_all_by_name
    item = item_repository.find_all_by_name("Item")

    assert_equal 3, item.size
  end

  def test_find_all_by_description
    items = item_repository
      .find_all_by_description("Ea Voluptatum,Sunt officia eum qui molestiae.")
    items1 = item_repository
      .find_all_by_description("Autem Minima,Cumque consequuntur ad.")

    assert_equal 1, items.size
    assert_equal 1, items1.count
  end

  def test_find_all_by_unit_price
    item = item_repository.find_all_by_unit_price(BigDecimal.new("67076") / 100)

    assert_equal 2, item.size
  end

  def test_find_all_by_merchant_id
    items = item_repository.find_all_by_merchant_id(1)

    assert_equal 3, items.size
  end

  def test_it_delegates_merchant_to_sales_engine
    sales_engine.expect(:find_merchant_from, nil, [1])
    item_repository.find_merchant_from(1)
    sales_engine.verify
  end

  def test_it_delegates_invoice_to_sales_engine
    sales_engine.expect(:find_invoice_items_from, nil, [7])
    item_repository.find_invoice_items_from(7)
    sales_engine.verify
  end

  def test_it_delegates_revenue_to_sales_engine
    sales_engine.expect(:find_most_revenue_items, nil, [2])
    item_repository.most_revenue(2)
    sales_engine.verify
  end
end
