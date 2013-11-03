require 'minitest_helper'
require 'converts_rates'

class ConvertsRatesTest < Minitest::Spec

  test "converts given rates" do
    rates = [{from: :USD, to: :AUD, conversion: 1.4}]
    converter = ConvertsRates.new(rates: rates)
    converter.convert(1.2, :USD, :AUD).must_equal BigDecimal('1.68')
  end

  test "converts inverse rates" do
    rates = [{from: :USD, to: :AUD, conversion: 1.4}]
    converter = ConvertsRates.new(rates: rates)
    converted = converter.convert(1.2, :AUD, :USD).truncate(3)
    converted.must_equal BigDecimal('0.857')
  end

  test "handles missing conversions" do
    converter = ConvertsRates.new(rates: [])
    converter.convert(1.2, :FOO, :BAR).must_equal :no_conversion
  end

  test "derives conversion rates" do
    rates = [
      {from: :FOO, to: :BAR, conversion: 1.1},
      {from: :BAR, to: :BAZ, conversion: 1.2},
      {from: :BAZ, to: :QUX, conversion: 1.3}
    ]
    converter = ConvertsRates.new(rates: rates)
    converter.convert(1.2, :FOO, :BAZ).truncate(3).must_equal BigDecimal('1.584')
    converter.convert(1.2, :FOO, :QUX).truncate(3).must_equal BigDecimal('2.059')
  end

end
