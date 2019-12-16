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
    @sup_1 = Boat.new(:standup_paddle_board, 15)
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
end
