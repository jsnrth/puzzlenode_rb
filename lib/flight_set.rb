require 'date'
require 'bigdecimal'

class FlightSet

  def initialize(flights)
    @flights = flights.dup
  end

  def flight_paths(from, to)
    direct(from, to) + connections(from, to)
  end

  private

  def direct(from, to)
    @flights.select { |f| f.from == from && f.to == to }.map { |d| [d] }
  end

  def connections(from, to)
    @flights.select { |f| f.from == from }.reduce([]) do |connections, flight|
      paths = calculate_paths(flight, to)
      connections << paths unless paths.empty?
      connections
    end
  end

  def calculate_paths(flight, destination)
    flight.connections(@flights).reduce([]) do |paths, connection|
      if connection.connects?(destination, @flights)
        paths << ([flight, connection] + calculate_paths(connection, destination)).uniq
      end
      paths.flatten
    end
  end

end

Flight = Struct.new(:from, :to, :depart, :arrive, :price) do

  def set_data(data = {})
    members.each do |member|
      self[member] = data.fetch(member) { :"no_#{member}" }
    end
    self
  end

  def connections(flights)
    flights.select { |f2| to == f2.from && arrive < f2.depart }
  end

  def connects?(destination, flights)
    to == destination || connections(flights).any? { |c| c.connects?(destination, flights) }
  end

end
