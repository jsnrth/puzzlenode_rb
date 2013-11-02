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

end
