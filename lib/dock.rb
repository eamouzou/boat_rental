class Dock
  attr_reader :name, :max_rental_time, :boats, :boats_to_be_returned

  def initialize(name, max_rental_time)
    @name = name
    @max_rental_time = max_rental_time
    @boats  = []
    @boats_to_be_returned = []
  end

  def rent(boat, renter)
    @boats << boat
    @boats_to_be_returned << boat
    boat.renter << renter
  end

  def rental_log
    #{boat => renter}
    @boats.reduce({}) do |acc, boat|
      acc[boat] = boat.renter[0]
      acc
    end
  end

  def charge(boat)
    x = {}
    x[:card_number] = boat.renter[0].credit_card_number
    if boat.hours_rented > @max_rental_time
      x[:amount] = boat.price_per_hour * @max_rental_time
    else
      x[:amount] = boat.price_per_hour * boat.hours_rented
    end
    x
  end

  def log_hour
    @boats.each {|boat| boat.add_hour}
  end

  def revenue
    rev_array = boats.map do |boat|
      if boat.empty? == true
        boat.price_per_hour * boat.hours_rented
      else
        0
      end
    end
    rev_array.sum
  end

  def return(boat)
    boat.renter.clear
    @boats_to_be_returned.delete(boat)
  end
end
