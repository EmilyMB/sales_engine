require_relative 'test_helper'
require_relative '../lib/item'

class ItemTest < Minitest::Test
  attr_reader :item, :data, :parent

  def test_item_exists
  end

  def setup
    @data = {
      id: '4',
      name: 'Nemo Facere',
      description: 'Sunt eum id eius magni consequuntur delectus veritatis.',
      unit_price: '4291',
      merchant_id: '1',
      created_at: '2012-03-27 14:53:59 UTC',
      updated_at: '2012-03-27 14:53:59 UTC'
    }
    @parent = Minitest::Mock.new
    @item = Item.new(data, parent)

  end

  def test_item_info
    assert_equal 4, item.id
    assert_equal 'Nemo Facere', item.name
    assert_equal 'Sunt eum id eius magni consequuntur delectus veritatis.',  item.description
    assert_equal '4291', item.unit_price
    assert_equal '1', item.merchant_id
    assert_equal '2012-03-27 14:53:59 UTC', item.created_at
    assert_equal '2012-03-27 14:53:59 UTC', item.updated_at
  end
end
