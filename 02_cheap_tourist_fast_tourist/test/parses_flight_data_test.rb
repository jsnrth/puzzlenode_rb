require 'minitest_helper'
require 'parses_flight_data'

class ParsesFlightDataTest < Minitest::Spec

  def fixture
<<-FIXTURE
1

3
A B 09:00 10:00 100.00
B Z 11:30 13:30 100.00
A Z 10:00 12:00 300.00
FIXTURE
  end

  specify "parses a data file" do
    sets = ParsesFlightData.new.parse_data_file_contents(fixture)
    assert_equal 1, sets.length

    set = sets.first
    assert_equal 3, set.flights.length
    set.flights.must_include Flight.new.set_data(from: :A, to: :B, depart: DateTime.parse('09:00'), arrive: DateTime.parse('10:00'), price: BigDecimal('100.00'))
    set.flights.must_include Flight.new.set_data(from: :B, to: :Z, depart: DateTime.parse('11:30'), arrive: DateTime.parse('13:30'), price: BigDecimal('100.00'))
    set.flights.must_include Flight.new.set_data(from: :A, to: :Z, depart: DateTime.parse('10:00'), arrive: DateTime.parse('12:00'), price: BigDecimal('300.00'))
  end

end
