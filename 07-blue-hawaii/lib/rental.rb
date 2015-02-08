require 'forwardable'

class Rental

  attr_reader :name, :seasons, :cleaning_fee

  def initialize(name, seasons, cleaning_fee)
    @name = name
    @seasons = seasons
    @cleaning_fee = cleaning_fee
  end

  def rates_for_date_range(checkin, checkout)
    (checkin...checkout).map do |date|
      [date, rate_for_date(date)]
    end
  end

  def rate_for_date(date)
    season = seasons.find do |season|
      ranges = season.md_range.date_ranges_for_year(date.year)
      ranges.any? { |range| range.include?(date) }
    end
    season.nil? ? :no_season : season.rate
  end

  def estimate_for_date_range(checkin, checkout, sales_tax: BigDecimal('0.0'))
    rates = rates_for_date_range(checkin, checkout)
    total_rate = rates.map(&:last).reduce(&:+)
    case cleaning_fee
    when Numeric
      total_rate + cleaning_fee
    else
      total_rate
    end * (1 + sales_tax)
  end

  Season = Struct.new(:name, :md_range, :rate) do
    extend Forwardable
    def_delegators :md_range, :start_md, :end_md
  end
end
