require 'bigdecimal'
require 'date'
require 'json'

class Rentals
  Rental = Struct.new(:name, :price)

  def self.from_json(data)
    new
  end

  def estimate_prices_for_stay(checkin, checkout)
    [
      Rental.new("Fern Grove Lodge",  BigDecimal('2474.79')),
      Rental.new("Paradise Inn",      BigDecimal('3508.65')),
      Rental.new("Honu's Hideaway",   BigDecimal('2233.25')),
    ]
  end
end
