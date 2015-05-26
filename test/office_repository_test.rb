require_relative '../lib/office_repository'
require_relative 'test_helper'

class OfficeRepoTest < Minitest::Test
  def setup
    @data = [{id: 1, created_at:"2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"},
      {id: 2, created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"},
      {id: 3, created_at: "2012-03-27 14:54:09 UTC", updated_at: "2012-03-27 14:54:09 UTC"}
    ]
    @office_repo = OfficeRepository.new(@data)
  end

  def test_returns_all
    assert_equal @data.length, @office_repo.all.length
  end

  def test_random
    assert_equal OfficeObj, @office_repo.random.class
  end

  def test_find_by_id
    office_objs = @office_repo.find_by_id(1)
    office_objs1 = @office_repo.find_by_id(45)
    assert_equal OfficeObj, office_objs.class
    assert_equal 1, office_objs.id
    assert_nil(office_objs1)
  end

  def test_find_by_created_at
    office_objs = @office_repo.find_by_created_at("2012-03-27 14:54:09 UTC")
    office_objs1 = @office_repo.find_by_created_at("2016-01-01")
    assert_equal OfficeObj, office_objs.class
    assert_nil(office_objs1)
  end

  def test_find_by_updated_at
    office_objs = @office_repo.find_by_updated_at("2012-03-27 14:54:09 UTC")
    office_objs1 = @office_repo.find_by_updated_at("2016-01-01")
    assert_equal OfficeObj, office_objs.class
    assert_nil(office_objs1)
  end

  def test_find_all_by_id
    office_objs = @office_repo.find_all_by_id(1)
    office_objs1 = @office_repo.find_all_by_id(45)
    assert_equal 1, office_objs.size
    assert_equal 0, office_objs1.size
  end

  def test_find_all_by_created_at
    office_objs = @office_repo.find_all_by_created_at("2012-03-27 14:54:09 UTC")
    office_objs1 = @office_repo.find_all_by_created_at("2016-01-01")
    assert_equal 3, office_objs.size
    assert_equal 0, office_objs1.size
  end

  def test_find_all_by_updated_at
    office_objs = @office_repo.find_all_by_updated_at("2012-03-27 14:54:09 UTC")
    office_objs1 = @office_repo.find_all_by_updated_at("2016-01-01")
    assert_equal 3, office_objs.size
    assert_equal 0, office_objs1.size
  end
end
