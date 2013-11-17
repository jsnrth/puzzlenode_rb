require 'bigdecimal'

class FlightPath

  attr_reader :flights

  def initialize(flights)
    @flights = flights
  end

  def travel_time
    return :no_flights if flights.empty?
    departs_at = flights.first.depart.to_time.to_i
    arrives_at = flights.last.arrive.to_time.to_i
    arrives_at - departs_at
  end

  def price
    return :no_flights if flights.empty?
    flights.map(&:price).reduce(BigDecimal('0'), :+)
  end

end
