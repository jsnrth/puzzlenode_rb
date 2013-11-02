require 'bigdecimal'
require 'bigdecimal/util'

class ConvertsRates

  NoConversion = Class.new(StandardError)

  def initialize(config = {})
    @rates = populate_rates(config.fetch(:rates){ [] })
  end

  def convert(amount, from, to)
    amount.to_d * conversion(from, to)
  rescue NoConversion
    :no_conversion
  end

  private

  def populate_rates(rates)
    rates.map do |rate|
      from = rate.fetch(:from) { :NA }.to_sym
      to = rate.fetch(:to) { :NA }.to_sym
      conversion = rate.fetch(:conversion) { 1.0 }.to_f
      [
        {[from, to] => conversion},
        {[to, from] => (1.0 / conversion)}
      ]
    end.flatten.reduce({}){|m,r| m.merge(r)}
  end

  def conversion(from, to)
    @rates.fetch([from, to]) { raise NoConversion, "no conversion from #{from} to #{to}" }
  end

end
