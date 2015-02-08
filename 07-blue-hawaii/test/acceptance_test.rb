require 'minitest_helper'
require 'rentals'

class AcceptanceTest < Minitest::Test

  def test_calculates_rates
    data_file = File.expand_path('./test_rentals.json', File.dirname(__FILE__))
    contents = File.read(data_file)
    rentals = Rentals.from_json(contents)

    checkin   = Date.parse('2011/05/07')
    checkout  = Date.parse('2011/05/20')

    sales_tax = BigDecimal('0.0411416')

    estimates = rentals.estimate_prices_for_stay(checkin, checkout, sales_tax: sales_tax)

    fern_grove_lodge  = estimates.find(:no_estimate) { |e| e.name == "Fern Grove Lodge" }
    paradise_inn      = estimates.find(:no_estimate) { |e| e.name == "Paradise Inn" }
    honus_hideaway    = estimates.find(:no_estimate) { |e| e.name == "Honu's Hideaway" }

    assert_in_delta BigDecimal('2474.79'), fern_grove_lodge.price, 0.01
    assert_in_delta BigDecimal('3508.65'), paradise_inn.price, 0.01
    assert_in_delta BigDecimal('2233.25'), honus_hideaway.price, 0.01
  end

end
