require 'bigdecimal'
require 'bigdecimal/util'

class ConvertsRates

  NoConversion = Class.new(StandardError)

  def initialize(config = {})
    @rates = populate_rates(config.fetch(:rates){ [] })
  end

  def convert(amount, from, to)
    amount.to_d * conversion_rate(from, to)
  rescue NoConversion
    :no_conversion
  end

  private

  def populate_rates(rates_data)
    rates_data.reduce([]) do |rates, rate_data|
      rate = Rate.new.set_data(rate_data)
      rates << rate
      rates << rate.inverse
      rates
    end
  end

  def conversion_rate(from, to)
    rate =
      @rates.find do |rate|
        rate.converts?(from, to)
      end || raise(NoConversion, "no conversion from #{from} to #{to}")
    rate.conversion
  end

  Rate = Struct.new(:from, :to, :conversion) do
    def set_data(data)
      self[:from] = data.fetch(:from).to_sym
      self[:to] = data.fetch(:to).to_sym
      self[:conversion] = data.fetch(:conversion).to_d
      self
    end

    def inverse
      Rate.new.set_data({
        from: to,
        to: from,
        conversion: (1.0.to_d / conversion)
      })
    end

    def converts?(from, to)
      self[:from] == from && self[:to] == to
    end
  end

end
