require 'bigdecimal'
require 'date'
require 'json'
require 'forwardable'

class Rentals
  PriceEstimate = Struct.new(:name, :price)

  TRANSIENT_SALES_TAX = BigDecimal('0.0411416')

  def initialize(rentals, sales_tax: TRANSIENT_SALES_TAX)
    @rentals = rentals
    @sales_tax = sales_tax
  end

  def length
    @rentals.length
  end

  def self.from_json(json)
    Rentals.new(ParsesData.new.parse_json(json))
  end

  def estimate_prices_for_stay(checkin, checkout)
    @rentals.map do |rental|
      PriceEstimate.new(
        rental.name,
        rental.estimate_for_date_range(checkin, checkout, sales_tax: @sales_tax))
    end
  end

  class ParsesData
    def parse_json(json)
      from_stringified_hashes(JSON.parse(json))
    end

    def from_stringified_hashes(hashes)
      hashes.map { |data| from_stringified_hash(data) }
    end

    def from_stringified_hash(hash)
      name = hash.fetch('name')
      seasons = hash.fetch('seasons') { [] }.map { |season|
        season.map { |(name, data)|
          starts = data['start'].to_s.split('-').map(&:to_i)
          start_md = MonthDay.new(starts[0], starts[1])
          ends = data['end'].to_s.split('-').map(&:to_i)
          end_md = MonthDay.new(ends[0], ends[1])
          md_range = MonthDayRange.new(start_md, end_md)
          rate = BigDecimal(data['rate'].to_s.gsub(/\$/, ''))
          Season.new(name, md_range, rate)
        }
      }.flatten
      raw_rate = hash.fetch('rate') { nil }
      rate = raw_rate.nil? ? :seasonal_rates : BigDecimal(raw_rate.to_s.gsub(/\$/, ''))
      raw_cleanfee = hash.fetch('cleaning fee') { nil }
      cleanfee = raw_cleanfee.nil? ? :none : BigDecimal(raw_cleanfee.to_s.gsub(/\$/, ''))
      Rental.new(name, seasons, rate, cleanfee)
    end
  end

  Rental = Struct.new(:name, :seasons, :rate, :cleaning_fee) do
    def rates_for_date_range(checkin, checkout)
      (checkin...checkout).map do |date|
        [date, rate_for_date(date)]
      end
    end

    def rate_for_date(date)
      return rate if rate.kind_of?(Numeric)

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
  end

  Season = Struct.new(:name, :md_range, :rate) do
    extend Forwardable
    def_delegators :md_range, :start_md, :end_md
  end

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

end
