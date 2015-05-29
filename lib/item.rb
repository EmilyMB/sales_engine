require "bigdecimal"

class Item
  attr_reader :id, :name, :description, :unit_price, :merchant_id, :created_at,
              :updated_at, :repo

  def initialize(data, repo)
    @id = data[:id].to_i
    @name = data[:name]
    @description = data[:description]
    @unit_price = BigDecimal.new(data[:unit_price]) / 100
    @merchant_id = data[:merchant_id].to_i
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repo = repo
  end

  def merchant
    repo.find_merchant_from(merchant_id)
  end

  def invoice_items
    repo.find_invoice_items_from(id)
  end

  def best_day
    repo.find_best_day_for(id)
  end
end
