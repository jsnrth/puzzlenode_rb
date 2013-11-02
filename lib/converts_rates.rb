class ConvertsRates

  def initialize(config = {})
    @rates = populate_rates(config.fetch(:rates){ [] })
  end

  def convert(amount, from, to)
    amount * conversion(from, to)
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
    end.flatten.reduce(:merge)
  end

  def conversion(from, to)
    @rates[[from, to]]
  end

end
