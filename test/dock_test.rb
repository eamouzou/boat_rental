require 'minitest/autorun'
require 'minitest/pride'
require './lib/boat'
require './lib/renter'
require './lib/dock'

class DockTest < Minitest::Test
  def setup
    @dock = Dock.new("The Rowing Dock", 3)
    @kayak_1 = Boat.new(:kayak, 20)
    @kayak_2 = Boat.new(:kayak, 20)
    @canoe = Boat.new(:canoe, 25)
    @sup_1 = Boat.new(:standup_paddle_board, 15)
    @sup_2 = Boat.new(:standup_paddle_board, 15)
    @patrick = Renter.new("Patrick Star", "4242424242424242")
    @eugene = Renter.new("Eugene Crabs", "1313131313131313")
  end

  def test_it_exists

    assert_instance_of Dock, @dock
  end

  def test_attributes

    assert_equal "The Rowing Dock", @dock.name
    assert_equal 3, @dock.max_rental_time
    assert_equal [], @dock.boats
  end

  def test_it_rents
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    assert_equal [@patrick], @kayak_1.renter
    assert_equal [@patrick], @kayak_2.renter
    assert_equal [@eugene], @sup_1.renter
  end

  def test_rental_log
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)

    assert_equal ({@kayak_1 => @patrick,
      @kayak_2 => @patrick,
      @sup_1 => @eugene}), @dock.rental_log
  end

  def test_it_can_charge
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.rent(@sup_1, @eugene)
    @kayak_1.add_hour
    @kayak_1.add_hour

    assert_equal ({:card_number => "4242424242424242",
      :amount => 40}), @dock.charge(@kayak_1)

    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour
    @sup_1.add_hour

    assert_equal ({:card_number => "1313131313131313",
      :amount => 45}), @dock.charge(@sup_1)
  end

  def test_it_can_log_hour
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour

    assert_equal 1, @kayak_1.hours_rented
    assert_equal 1, @kayak_2.hours_rented

    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    assert_equal 2, @kayak_1.hours_rented
    assert_equal 2, @kayak_2.hours_rented
    assert_equal 1, @canoe.hours_rented
  end

  def test_no_revenue_until_return
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour

    assert_equal 0, @dock.revenue
  end

  def test_revenue_after_returns
    @dock.rent(@kayak_1, @patrick)
    @dock.rent(@kayak_2, @patrick)
    @dock.log_hour
    @dock.rent(@canoe, @patrick)
    @dock.log_hour
    @dock.return(@kayak_1)
    @dock.return(@kayak_2)
    @dock.return(@canoe)

    assert_equal 105, @dock.revenue
  end
end
