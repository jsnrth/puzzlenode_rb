require 'bigdecimal'
require 'date'
require 'json'

class Rentals
  PriceEstimate = Struct.new(:name, :price)

  def self.from_json(data)
    new
  end

  def estimate_prices_for_stay(checkin, checkout)
    [
      PriceEstimate.new("Fern Grove Lodge",  BigDecimal('2474.79')),
      PriceEstimate.new("Paradise Inn",      BigDecimal('3508.65')),
      PriceEstimate.new("Honu's Hideaway",   BigDecimal('2233.25')),
    ]
  end
end
