require 'minitest_helper'
require 'converts_rates'

class ConvertsRatesTest < Minitest::Spec

  test "converts given rates" do
    rates = [{from: :USD, to: :AUD, conversion: 1.4}]
    converter = ConvertsRates.new(rates: rates)
    assert_equal 1.68, converter.convert(1.2, :USD, :AUD)
  end

  test "converts inverse rates" do
    rates = [{from: :USD, to: :AUD, conversion: 1.4}]
    converter = ConvertsRates.new(rates: rates)
    assert_equal 0.8571428571428571, converter.convert(1.2, :AUD, :USD)
  end

end
