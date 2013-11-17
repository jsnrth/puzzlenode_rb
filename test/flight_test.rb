require 'minitest_helper'
require 'date'
require 'bigdecimal'
require 'flight'

class FlightTest < Minitest::Spec

  let(:ab) { Flight.new.set_data(from: :A, to: :B, depart: DateTime.parse('09:00'), arrive: DateTime.parse('10:00'), price: BigDecimal('100.00')) }
  let(:ae) { Flight.new.set_data(from: :A, to: :E, depart: DateTime.parse('11:45'), arrive: DateTime.parse('14:15'), price: BigDecimal('225.50')) }
  let(:az) { Flight.new.set_data(from: :A, to: :Z, depart: DateTime.parse('10:00'), arrive: DateTime.parse('12:00'), price: BigDecimal('300.00')) }
  let(:be) { Flight.new.set_data(from: :B, to: :E, depart: DateTime.parse('10:15'), arrive: DateTime.parse('11:15'), price: BigDecimal('115.50')) }
  let(:bz) { Flight.new.set_data(from: :B, to: :Z, depart: DateTime.parse('11:30'), arrive: DateTime.parse('13:30'), price: BigDecimal('100.00')) }
  let(:ef) { Flight.new.set_data(from: :E, to: :F, depart: DateTime.parse('11:30'), arrive: DateTime.parse('12:45'), price: BigDecimal('200.00')) }

  specify "connects?" do
    # direct
    assert ab.connects?(:B, [ab])
    refute ab.connects?(:Z, [ab])
    assert az.connects?(:Z, [az])
    refute az.connects?(:B, [az])

    # through connections
    assert ab.connects?(:F, [ab, be, ef])
    refute ab.connects?(:Z, [ab, be, ef])

    # no flights
    refute ab.connects?(:Q, [])

    # mismatched times
    refute ae.connects?(:F, [ae, ef])
  end

  specify "connections" do
    flights = [ab, ae, az, be, bz, ef]
    ab.connections(flights).must_equal [be, bz]
    be.connections(flights).must_equal [ef]
    ef.connections(flights).must_equal []
  end

end
