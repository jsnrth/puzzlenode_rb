require 'minitest_helper'
require 'converts_rates'

class ConvertsRatesTest < Minitest::Spec

  test "converts rates" do
    rates = [{from: :USD, to: :AUD, conversion: 1.4}]
    converter = ConvertsRates.new(rates: rates)
    assert_equal 1.4, converter.convert(1.0, :USD, :AUD)
  end

end
