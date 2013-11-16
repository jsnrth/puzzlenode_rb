require 'date'
require 'bigdecimal'

class FlightSet

  def initialize(flights)
    @flights = flights.map { |flight| flight.set_connections(flights) }
  end

  def flight_paths(from, to)
    direct = @flights.select { |f| f.from == from && f.to == to }.map { |d| [d] }
    direct + connections(from, to)
  end

  private

  def connections(from, to)
    @flights.select { |f| f.from == from }.reduce([]) do |connections, flight|
      paths = flight.paths_to(to)
      connections << paths unless paths.empty?
      connections
    end
  end

end

class Flight
  attr_reader :from, :to, :depart, :arrive, :price, :connections
  private :connections

  def initialize(data = {})
    @from = data.fetch(:from) { :no_from }
    @to = data.fetch(:to) { :no_to }
    @depart = data.fetch(:depart) { :no_depart }
    @arrive = data.fetch(:arrive) { :no_arrive }
    @price = data.fetch(:price) { :no_price }
    @connections = []
  end

  def set_connections(flights)
    self.tap do |f|
      @connections = flights.select { |f2| f.to == f2.from && f.arrive < f2.depart }
    end
  end

  def connects?(destination)
    to == destination || connections.any? { |c| c.connects?(destination) }
  end

  def paths_to(destination)
    connections.reduce([]) do |paths, connection|
      if connection.connects?(destination)
        paths << ([self, connection] + connection.paths_to(destination)).uniq
      end
      paths.flatten
    end
  end

end
