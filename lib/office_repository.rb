require_relative "office_obj"

class OfficeRepository
  attr_reader :data

  def initialize(data)
    @data ||= data.map { |data| OfficeObj.new(data) }
  end

  def inspect
    "#<\#{self.class} \#{@data.size} rows>"
  end

  def all
    data
  end

  def random
    data.sample
  end

  def generic_find(attribute, criteria)
    data.find do |office_obj|
      office_obj.send(attribute.to_sym).downcase == criteria.downcase
    end
  end

  def generic_non_string_find(attribute, criteria)
    data.find { |office_obj| office_obj.send(attribute.to_sym) == criteria }
  end

  def find_by_id(criteria)
    generic_non_string_find("id", criteria)
  end

  def find_by_created_at(criteria)
    generic_non_string_find("created_at", criteria)
  end

  def find_by_updated_at(criteria)
    generic_non_string_find("updated_at", criteria)
  end

  def generic_find_all(attribute, criteria)
    data.select do |office_obj|
      office_obj.send(attribute.to_sym).downcase == criteria.downcase
    end
  end

  def generic_non_string_find_all(attribute, criteria)
    data.select { |office_obj| office_obj.send(attribute.to_sym) == criteria }
  end

  def find_all_by_id(criteria)
    generic_non_string_find_all("id", criteria)
  end

  def find_all_by_created_at(criteria)
    generic_non_string_find_all("created_at", criteria)
  end

  def find_all_by_updated_at(criteria)
    generic_non_string_find_all("updated_at", criteria)
  end
end
