require 'minitest_helper'
require 'parses_rates'

class ParsesRatesTest < Minitest::Spec

  def xml_fixture
    <<-XML
<?xml version="1.0"?>
<rates>
  <rate>
    <from>AUD</from>
    <to>CAD</to>
    <conversion>1.0079</conversion>
  </rate>
  <rate>
    <from>CAD</from>
    <to>USD</to>
    <conversion>1.0090</conversion>
  </rate>
  <rate>
    <from>USD</from>
    <to>CAD</to>
    <conversion>0.9911</conversion>
  </rate>
</rates>
    XML
  end

  test "parses XML rates" do
    rates = ParsesRates.new(xml_fixture).parsed_rates
    rates.must_equal [
      {from: :AUD, to: :CAD, conversion: BigDecimal('1.0079')},
      {from: :CAD, to: :USD, conversion: BigDecimal('1.0090')},
      {from: :USD, to: :CAD, conversion: BigDecimal('0.9911')}
    ]
  end

  test "creates a converter" do
    converter = ParsesRates.new(xml_fixture).converter
    assert_equal BigDecimal('1.51185'), converter.convert(1.5, :AUD, :CAD).truncate(5)
    assert_equal BigDecimal('1.51346'), converter.convert(1.5, :CAD, :USD).truncate(5)
  end

end
