require 'minitest_helper'
require 'flight_path'
require 'flight'
require 'date'

class FlightPathTest < Minitest::Spec

  let(:ab) { Flight.new.set_data(from: :A, to: :B, depart: DateTime.parse('09:00'), arrive: DateTime.parse('10:00'), price: BigDecimal('100.00')) }
  let(:az) { Flight.new.set_data(from: :A, to: :Z, depart: DateTime.parse('10:00'), arrive: DateTime.parse('12:00'), price: BigDecimal('300.00')) }
  let(:bz) { Flight.new.set_data(from: :B, to: :Z, depart: DateTime.parse('11:30'), arrive: DateTime.parse('13:30'), price: BigDecimal('100.00')) }

  specify "totals price" do
    assert_equal BigDecimal('200.00'), FlightPath.new([ab, bz]).price
    assert_equal BigDecimal('300.00'), FlightPath.new([az]).price
    assert_equal :no_flights, FlightPath.new([]).price
  end

  specify "totals travel time in seconds" do
    assert_equal 7200, FlightPath.new([az]).travel_time
    assert_equal 16200, FlightPath.new([ab, bz]).travel_time
    assert_equal :no_flights, FlightPath.new([]).travel_time
  end

end
