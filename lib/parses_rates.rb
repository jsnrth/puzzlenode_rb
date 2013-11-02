require 'nokogiri'
require 'bigdecimal'
require 'bigdecimal/util'
require 'converts_rates'

class ParsesRates

  def initialize(xml_string)
    @xml_string = xml_string
  end

  def parsed_rates
    xml = Nokogiri::XML::Document.parse(@xml_string)
    xml.search('rate').map do |rate_node|
      children = rate_node.children
      {
        from: children.search('from').text.to_sym,
        to: children.search('to').text.to_sym,
        conversion: children.search('conversion').text.to_d,
      }
    end
  end

  def converter
    @converter ||= ConvertsRates.new(rates: parsed_rates)
  end

end
