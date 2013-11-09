require 'csv'
require 'bigdecimal'

class ParsesTransactions

  def parse_transactions_csv(csv_string)
    transactions = []
    CSV.parse(csv_string, headers: true) do |row|
      store   = row['store']
      sku     = row['sku']
      amount, currency  = row['amount'].split(' ')

      transactions << Transaction.new.set_data({
        store: store,
        sku: sku,
        amount: BigDecimal(amount),
        currency: currency.to_sym
      })
    end
    transactions
  end

  Transaction = Struct.new(:store, :sku, :amount, :currency) do
    def set_data(data)
      members.each do |member|
        self[member] = data[member]
      end
      self
    end
  end

end
