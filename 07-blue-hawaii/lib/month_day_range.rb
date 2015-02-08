require 'date'

MonthDay = Struct.new(:month, :day) do
  def date_for_year(year)
    Date.new(year, month, day)
  end
end

MonthDayRange = Struct.new(:start_md, :end_md) do
  def date_ranges_for_year(year)
    startd = start_md.date_for_year(year)
    endd   = end_md.date_for_year(year)
    if startd < endd
      [(startd..endd)]
    else
      [
        (Date.new(year, 1, 1)..endd),
        (startd..Date.new(year, 12, 31))
      ]
    end
  end
end
