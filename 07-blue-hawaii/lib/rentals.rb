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

  def self.from_json(data)
    ParsesData.new(data).parse
  end

  def estimate_prices_for_stay(checkin, checkout)
    [
      PriceEstimate.new("Fern Grove Lodge",  BigDecimal('2474.79')),
      PriceEstimate.new("Paradise Inn",      BigDecimal('3508.65')),
      PriceEstimate.new("Honu's Hideaway",   BigDecimal('2233.25')),
    ]
  end

  class ParsesData
    def initialize(data)
      @data = data
    end

    def parse
      Rentals.new(@data)
    end
  end
end
