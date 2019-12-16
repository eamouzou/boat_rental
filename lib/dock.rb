class Dock
  attr_reader :name, :max_rental_time, :rental_log

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @renters  = {}
  end

  def rent(boat, renter)
    renter.rented_boat << boat
  end

  def rental_log
    #{boat => renter}
  end
end
