require 'bigdecimal'
require 'date'
require 'json'
require 'month_day_range'
require 'rental'

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

  def estimate_prices_for_stay(checkin, checkout, sales_tax: BigDecimal('0.0'))
    @rentals.map do |rental|
      PriceEstimate.new(
        rental.name,
        rental.estimate_for_date_range(checkin, checkout, sales_tax: sales_tax))
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
          Rental::Season.new(name, md_range, rate)
        }
      }.flatten
      raw_rate = hash.fetch('rate') { nil }
      if seasons.empty? && !raw_rate.nil?
        seasons = [
          Rental::Season.new(
            'year',
            MonthDayRange.new(MonthDay.new(1, 1), MonthDay.new(12, 31)),
            BigDecimal(raw_rate.to_s.gsub(/\$/, '')))
        ]
      end

      raw_cleanfee = hash.fetch('cleaning fee') { nil }
      cleanfee = raw_cleanfee.nil? ? :none : BigDecimal(raw_cleanfee.to_s.gsub(/\$/, ''))
      Rental.new(name, seasons, cleanfee)
    end
  end

end
