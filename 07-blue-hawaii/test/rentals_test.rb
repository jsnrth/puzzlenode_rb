require 'minitest_helper'
require 'rentals'
require 'rental'

class RentalsTest < Minitest::Test

  def seasonal_rental
    @@seasonal_rental ||= Rentals::ParsesData.new.from_stringified_hash({
      "name" => "Fern Grove Lodge",
      "seasons" => [
        {
          "one" => {
            "start" => "05-01",
            "end" => "05-13",
            "rate" => "$137"
          }
        },
        {
          "two" => {
            "start" => "05-14",
            "end" => "04-30",
            "rate" => "$220"
          }
        }
      ],
      "cleaning fee" => "$98"
    })
  end

  def non_seasonal_rental
    @@non_seasonal_rental ||= Rentals::ParsesData.new.from_stringified_hash({
      "name" => "Paradise Inn",
      "rate" => "$250",
      "cleaning fee" => "$120"
    })
  end

  def test_lists_rates_within_date_range
    checkin   = Date.parse('2011/05/07')
    checkout  = Date.parse('2011/05/10')

    rates = seasonal_rental.rates_for_date_range(checkin, checkout)
    assert_equal [
      [Date.parse('2011-05-07'), BigDecimal('137')],
      [Date.parse('2011-05-08'), BigDecimal('137')],
      [Date.parse('2011-05-09'), BigDecimal('137')]
    ], rates
  end

  def test_lists_rates_for_dates_of_non_seasonal_rental
    checkin   = Date.parse('2011/05/07')
    checkout  = Date.parse('2011/05/10')

    rates = non_seasonal_rental.rates_for_date_range(checkin, checkout)
    assert_equal [
      [Date.parse('2011-05-07'), BigDecimal('250')],
      [Date.parse('2011-05-08'), BigDecimal('250')],
      [Date.parse('2011-05-09'), BigDecimal('250')]
    ], rates
  end

  def test_lists_rates_across_seasons
    checkin   = Date.parse('2011/05/12')
    checkout  = Date.parse('2011/05/17')

    rates = seasonal_rental.rates_for_date_range(checkin, checkout)
    assert_equal [
      [Date.parse('2011-05-12'), BigDecimal('137')],
      [Date.parse('2011-05-13'), BigDecimal('137')],
      [Date.parse('2011-05-14'), BigDecimal('220')],
      [Date.parse('2011-05-15'), BigDecimal('220')],
      [Date.parse('2011-05-16'), BigDecimal('220')]
    ], rates
  end

  def test_gets_rate_for_date
    rate = seasonal_rental.rate_for_date(Date.parse('2011/05/07'))
    assert_equal BigDecimal('137'), rate

    rate = seasonal_rental.rate_for_date(Date.parse('2013/09/01'))
    assert_equal BigDecimal('220'), rate

    rate = seasonal_rental.rate_for_date(Date.parse('2012/04/01'))
    assert_equal BigDecimal('220'), rate
  end

  def test_calculates_estimate_for_date_range
    checkin   = Date.parse('2011/05/07')
    checkout  = Date.parse('2011/05/10')
    estimate = seasonal_rental.estimate_for_date_range(checkin, checkout)
    assert_equal BigDecimal('509'), estimate
  end

  def test_calculates_estimate_for_date_over_seasons
    checkin   = Date.parse('2011/05/12')
    checkout  = Date.parse('2011/05/17')
    estimate = seasonal_rental.estimate_for_date_range(checkin, checkout)
    assert_equal BigDecimal('1032'), estimate
  end

  def test_calculates_estimate_for_date_range_of_non_seasonal
    checkin   = Date.parse('2011/05/07')
    checkout  = Date.parse('2011/05/10')
    estimate = non_seasonal_rental.estimate_for_date_range(checkin, checkout)
    assert_equal BigDecimal('870'), estimate
  end
end
