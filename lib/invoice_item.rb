require 'date'
require 'bigdecimal'

class InvoiceItem
  attr_reader :id, :item_id, :invoice_id, :quantity,
              :unit_price, :created_at, :updated_at, :repo

  def initialize(data, parent)
    @id = data[:id].to_i
    @item_id = data[:item_id].to_i
    @invoice_id = data[:invoice_id].to_i
    @quantity = data[:quantity].to_i
    @unit_price = BigDecimal.new(data[:unit_price])/100
    @created_at = Date.parse(data[:created_at])
    @updated_at = Date.parse(data[:updated_at])
    @repo = parent
  end

  def invoice
    repo.find_invoice_from(invoice_id)
  end

  def item
    repo.find_item_from(item_id)
  end
end
