require "csv"

class CsvReader
  def self.load_csv(filename)
    path = File.expand_path("./csvs/")
    file = File.join(path, filename)
    data = CSV.open(file, headers: true, header_converters: :symbol)
    output = []
    rows = data.map do |row|
      row.to_hash
    end
  end
end
