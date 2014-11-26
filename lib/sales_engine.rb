require 'csv'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'item_repository'
require_relative 'customer_repository'
require_relative 'transaction_repository'


class SalesEngine

  def initialize(filename)
    @data ||= customers.map {|customer| CustomerRepository.new(filename, self)}
  end

end
