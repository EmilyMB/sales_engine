require_relative "test_helper"
require_relative "../lib/csv_reader"

class CsvLoaderTest < Minitest::Test
  def test_it_exists
    file = CsvReader.new
  end

  def test_initialize_reader
    file = CsvReader.new
    assert "data/customers.csv"
  end
end
