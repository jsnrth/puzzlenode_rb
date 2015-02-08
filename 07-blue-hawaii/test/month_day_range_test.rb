require 'minitest_helper'
require 'rentals'

class MonthDayRangeTest < Minitest::Test

  def test_month_day_range_establishes_dates_from_year
    startmd = Rentals::MonthDay.new(5, 1)
    endmd = Rentals::MonthDay.new(5, 13)
    md_range = Rentals::MonthDayRange.new(startmd, endmd)
    assert_equal [
      (Date.parse('2012-05-01')..Date.parse('2012-05-13'))
    ], md_range.date_ranges_for_year(2012)
  end

  def test_month_day_range_establishes_dates_across_two_years
    startmd = Rentals::MonthDay.new(5, 14)
    endmd = Rentals::MonthDay.new(4, 1)
    md_range = Rentals::MonthDayRange.new(startmd, endmd)
    assert_equal [
      (Date.parse('2013-01-01')..Date.parse('2013-04-01')),
      (Date.parse('2013-05-14')..Date.parse('2013-12-31'))
    ], md_range.date_ranges_for_year(2013)
  end
end
