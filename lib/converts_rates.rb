require 'bigdecimal'
require 'bigdecimal/util'

class ConvertsRates

  NoConversion = Class.new(StandardError)

  def initialize(config = {})
    @rates = populate_rates(config.fetch(:rates){ [] })
  end

  def convert(amount, from, to)
    rate, new_rates = derive_conversion_rate(@rates, from, to)
    @rates += new_rates if new_rates.any?
    amount.to_d * rate.conversion
  rescue NoConversion
    :no_conversion
  end

  private

  def populate_rates(rates_data)
    rates_data.reduce([]) do |rates, rate_data|
      rate = Rate.new.set_data(rate_data)
      rates << rate << rate.inverse
    end
  end

  def derive_conversion_rate(rates, from, to, new_rates = [])
    all_rates = rates + new_rates
    new_rates_count = new_rates.count
    rate = all_rates.find {|rate| rate.converts?(from, to) }

    if rate
      [rate, new_rates]
    else
      froms = all_rates.select {|frate| frate.from == from}
      if froms.any?
        froms.each do |from_rate|
          tos = all_rates.select {|trate| trate.from == from_rate.to}
          if tos.any?
            tos.each do |to_rate|
              new_from = from_rate.from
              new_to = to_rate.to
              new_conversion = from_rate.conversion * to_rate.conversion
              is_dup = new_from == new_to
              exists = all_rates.find {|r| new_from == r.from && new_to == r.to }
              if !is_dup && !exists
                new_rates << Rate.new.set_data({
                  from: new_from,
                  to: new_to,
                  conversion: new_conversion
                })
              end
            end
          end
        end
      end

      any_new_rates = new_rates.count > new_rates_count
      if any_new_rates
        derive_conversion_rate(rates, from, to, new_rates)
      else
        raise NoConversion, "no conversion from #{from} to #{to}"
      end
    end
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
