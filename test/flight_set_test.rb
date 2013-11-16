require 'minitest_helper'
require 'flight_set'

class FlightSetTest < Minitest::Spec

  let(:ab) { Flight.new(from: :A, to: :B, depart: DateTime.parse('09:00'), arrive: DateTime.parse('10:00'), price: BigDecimal('100.00')) }
  let(:ae) { Flight.new(from: :A, to: :E, depart: DateTime.parse('11:45'), arrive: DateTime.parse('14:15'), price: BigDecimal('225.50')) }
  let(:az) { Flight.new(from: :A, to: :Z, depart: DateTime.parse('10:00'), arrive: DateTime.parse('12:00'), price: BigDecimal('300.00')) }
  let(:be) { Flight.new(from: :B, to: :E, depart: DateTime.parse('10:15'), arrive: DateTime.parse('11:15'), price: BigDecimal('115.50')) }
  let(:bz) { Flight.new(from: :B, to: :Z, depart: DateTime.parse('11:30'), arrive: DateTime.parse('13:30'), price: BigDecimal('100.00')) }
  let(:ef) { Flight.new(from: :E, to: :F, depart: DateTime.parse('11:30'), arrive: DateTime.parse('12:45'), price: BigDecimal('200.00')) }

  specify "fetches all flight paths" do
    fset = FlightSet.new([ab, ae, az, be, bz, ef])

    paths = fset.flight_paths(:A, :Z).map { |path| path.map { |f| [f.from, f.to] } }
    assert_equal 2, paths.length
    paths.must_include [[:A, :Z]]
    paths.must_include [[:A, :B], [:B, :Z]]

    paths = fset.flight_paths(:A, :E).map { |path| path.map { |f| [f.from, f.to] } }
    assert_equal 2, paths.length
    paths.must_include [[:A, :E]]
    paths.must_include [[:A, :B], [:B, :E]]

    paths = fset.flight_paths(:A, :F).map { |path| path.map { |f| [f.from, f.to] } }
    assert_equal 1, paths.length
    paths.must_include [[:A, :B], [:B, :E], [:E, :F]]
  end

end
