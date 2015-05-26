require_relative "../lib/invoice_item"
require_relative "test_helper"

class InvoiceItemTest < Minitest::Test
  attr_reader :parent, :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at, :invoice_item

  def setup
    data = {
      id: 45,
      item_id: 34696,
      invoice_id: 955,
      quantity: 2,
      unit_price: "3.15",
      created_at: "2010-01-01",
      updated_at: "2015-01-01"
    }
    @parent = Minitest::Mock.new
    @invoice_item = InvoiceItem.new(data, parent)
  end

  def test_invoice_item_attributes
    assert_equal 45, invoice_item.id
    assert_equal 34696, invoice_item.item_id
    assert_equal 955, invoice_item.invoice_id
    assert_equal 2, invoice_item.quantity
    assert_equal BigDecimal.new("3.15")/100, invoice_item.unit_price
    assert_equal Date.parse("2010-01-01"), invoice_item.created_at
    assert_equal Date.parse("2015-01-01"), invoice_item.updated_at
  end

  def test_it_delegates_invoice_to_parent_repo
    parent.expect(:find_invoice_from, nil, [955])
    invoice_item.invoice
    parent.verify
  end

  def test_it_delegates_item_to_parent_repo
    parent.expect(:find_item_from, nil, [34696])
    invoice_item.item
    parent.verify
  end
end
#
# invoice returns an instance of Invoice associated with this object
# item returns an instance of Item associated with this object
