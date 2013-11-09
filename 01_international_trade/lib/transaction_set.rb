require 'bigdecimal'
require 'converts_rates'

class TransactionSet

  def initialize(config = {})
    @transactions = config.fetch(:transactions){ [] }
    @converter = config.fetch(:converter) { ConvertsRates.new }
  end

  def total_for_sku(sku, currency = :USD)
    @transactions.select {|t| t.sku == sku}.reduce(BigDecimal('0')) do |total, transaction|
      total += @converter.convert(transaction.amount, transaction.currency, currency)
    end
  end

end
