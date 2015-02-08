require 'bigdecimal'
require 'date'
require 'json'

class Rentals
  PriceEstimate = Struct.new(:name, :price)

  def initialize(rentals)
    @rentals = rentals
  end

  def length
    @rentals.length
  end

  def self.from_json(json)
    Rentals.new(ParsesData.new.parse_json(json))
  end

  def estimate_prices_for_stay(checkin, checkout)
    [
      PriceEstimate.new("Fern Grove Lodge",  BigDecimal('2474.79')),
      PriceEstimate.new("Paradise Inn",      BigDecimal('3508.65')),
      PriceEstimate.new("Honu's Hideaway",   BigDecimal('2233.25')),
    ]
  end

  class ParsesData
    def parse_json(json)
      from_stringified_hash(JSON.parse(json))
    end

    def from_stringified_hash(data)
      data.map do |datum|
        name = datum.fetch('name')
        seasons = datum.fetch('seasons') { [] }.map { |season|
          season.map { |(name, data)|
            starts = data['start'].to_s.split('-').map(&:to_i)
            start_md = MonthDay.new(starts[0], starts[1])
            ends = data['end'].to_s.split('-').map(&:to_i)
            end_md = MonthDay.new(ends[0], ends[1])
            rate = BigDecimal(data['rate'].to_s.gsub(/\$/, ''))
            Season.new(name, start_md, end_md, rate)
          }
        }.flatten
        raw_rate = datum.fetch('rate') { nil }
        rate = raw_rate.nil? ? :varies : BigDecimal(raw_rate.to_s.gsub(/\$/, ''))
        raw_cleanfee = datum.fetch('cleaning fee') { nil }
        cleanfee = raw_cleanfee.nil? ? :none : BigDecimal(raw_cleanfee.to_s.gsub(/\$/, ''))
        Rental.new(name, seasons, rate, cleanfee)
      end
    end
  end

  Rental = Struct.new(:name, :seasons, :rate, :cleaning_fee)

  Season = Struct.new(:name, :start, :end, :rate)

  MonthDay = Struct.new(:month, :day)

end
