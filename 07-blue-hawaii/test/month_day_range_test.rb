require 'minitest_helper'
require 'month_day_range'

class MonthDayRangeTest < Minitest::Test

  def test_month_day_range_establishes_dates_from_year
    startmd   = MonthDay.new(5, 1)
    endmd     = MonthDay.new(5, 13)
    md_range  = MonthDayRange.new(startmd, endmd)
    assert_equal [
      (Date.parse('2012-05-01')..Date.parse('2012-05-13'))
    ], md_range.date_ranges_for_year(2012)
  end

  def test_month_day_range_establishes_dates_across_two_years
    startmd   = MonthDay.new(5, 14)
    endmd     = MonthDay.new(4, 1)
    md_range  = MonthDayRange.new(startmd, endmd)
    assert_equal [
      (Date.parse('2013-01-01')..Date.parse('2013-04-01')),
      (Date.parse('2013-05-14')..Date.parse('2013-12-31'))
    ], md_range.date_ranges_for_year(2013)
  end
end
