require 'date'
require 'bigdecimal'

class FlightSet

  def initialize(flights)
    @flights = flights.dup
  end

  def flight_paths(from, to)
    direct = @flights.select { |f| f.from == from && f.to == to }.map { |d| [d] }
    direct + connections(from, to)
  end

  private

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

class Flight
  attr_reader :from, :to, :depart, :arrive, :price

  def initialize(data = {})
    @from = data.fetch(:from) { :no_from }
    @to = data.fetch(:to) { :no_to }
    @depart = data.fetch(:depart) { :no_depart }
    @arrive = data.fetch(:arrive) { :no_arrive }
    @price = data.fetch(:price) { :no_price }
  end

  def connections(flights)
    flights.select { |f2| to == f2.from && arrive < f2.depart }
  end

  def connects?(destination, flights)
    to == destination || connections(flights).any? { |c| c.connects?(destination, flights) }
  end

end
