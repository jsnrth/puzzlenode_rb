require 'date'
require 'bigdecimal'
require 'flight'
require 'flight_path'

class FlightSet

  attr_reader :flights

  def initialize(flights)
    @flights = flights.dup
  end

  def flight_paths(from, to)
    (direct(from, to) + connections(from, to)).map { |flights| FlightPath.new(flights) }
  end

  private

  def direct(from, to)
    @flights.select { |f| f.from == from && f.to == to }.map { |d| [d] }
  end

  def connections(from, to)
    flights.select { |f| f.from == from }.reduce([]) do |connections, flight|
      paths = calculate_paths(flight, to)
      connections << paths unless paths.empty?
      connections
    end
  end

  def calculate_paths(flight, destination)
    flight.connections(flights).reduce([]) do |paths, connection|
      if connection.connects?(destination, flights)
        paths << ([flight, connection] + calculate_paths(connection, destination)).uniq
      end
      paths.flatten
    end
  end

end
