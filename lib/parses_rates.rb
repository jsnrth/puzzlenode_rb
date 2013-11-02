require 'nokogiri'
require 'bigdecimal'
require 'bigdecimal/util'

class ParsesRates

  def parse_rates_xml(xml_string)
    xml = Nokogiri::XML(xml_string)
    xml.search('rate').map do |rate_node|
      {
        from: rate_node.search('from').text.to_sym,
        to: rate_node.search('to').text.to_sym,
        conversion: rate_node.search('conversion').text.to_d,
      }
    end
  end

end
