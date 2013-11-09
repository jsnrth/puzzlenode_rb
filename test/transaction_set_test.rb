require 'minitest_helper'
require 'parses_transactions'
require 'transaction_set'

class TransactionSetTest < Minitest::Spec

  def transaction(data = {})
    ParsesTransactions::Transaction.new.set_data(data)
  end

  def transactions
    [
      transaction(store: 'Foo', sku: 'ABC123', amount: BigDecimal('70.00'), currency: :USD),
      transaction(store: 'Bar', sku: 'ABC123', amount: BigDecimal('19.68'), currency: :USD),
      transaction(store: 'Bar USD', sku: 'ABC234', amount: BigDecimal('21.12'), currency: :USD),
      transaction(store: 'Bar FOO', sku: 'ABC234', amount: BigDecimal('12.34'), currency: :FOO),
      transaction(store: 'Bar BAR', sku: 'ABC234', amount: BigDecimal('45.67'), currency: :BAR),
    ]
  end

  def converter
    ConvertsRates.new(rates: [
      {from: :FOO, to: :USD, conversion: BigDecimal('1.1')},
      {from: :BAR, to: :USD, conversion: BigDecimal('0.9')},
    ])
  end

  def transaction_set
    TransactionSet.new(transactions: transactions, converter: converter)
  end

  test "totals a sku from all stores by currency" do
    transaction_set.total_for_sku('ABC123').must_equal BigDecimal('89.68')
  end

  test "converts currencies before totaling (default USD)" do
    transaction_set.total_for_sku('ABC234').truncate(2).must_equal BigDecimal('75.79').truncate(2)
    transaction_set.total_for_sku('ABC234', :FOO).truncate(2).must_equal BigDecimal('68.90').truncate(2)
    transaction_set.total_for_sku('ABC234', :BAR).truncate(2).must_equal BigDecimal('84.21').truncate(2)
  end

end
