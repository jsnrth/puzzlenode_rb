require 'minitest_helper'
require 'parses_transactions'

class ParsesTransactionsTest < Minitest::Spec

  def parser
    ParsesTransactions.new
  end

  def transaction(data)
    ParsesTransactions::Transaction.new.set_data(data)
  end

  def fixture
    <<-CSV
store,sku,amount
Yonkers,DM1210,70.00 USD
Yonkers,DM1182,19.68 AUD
Nashua,DM1182,58.58 AUD
Scranton,DM1210,68.76 USD
Camden,DM1182,54.64 USD
    CSV
  end

  test "parses transactions" do
    transactions = parser.parse_transactions_csv(fixture)

    transactions[1].must_equal transaction({
      store: 'Yonkers',
      sku: 'DM1182',
      amount: BigDecimal('19.68'),
      currency: :AUD
    })

    transactions[3].must_equal transaction({
      store: 'Scranton',
      sku: 'DM1210',
      amount: BigDecimal('68.76'),
      currency: :USD
    })
  end

end
