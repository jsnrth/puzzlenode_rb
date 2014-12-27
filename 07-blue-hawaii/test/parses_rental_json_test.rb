require 'minitest_helper'
require 'rentals'

class ParsesJsonTest < Minitest::Test

  def test_parses_json
    data_file = File.expand_path('./test_rentals.json', File.dirname(__FILE__))
    data = JSON.parse(File.read(data_file))
    rentals = Rentals::ParsesData.new(data).parse
    assert_equal 3, rentals.length
  end

end
