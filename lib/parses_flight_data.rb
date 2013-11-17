require 'flight_set'

class ParsesFlightData

  def parse_data_file_contents(contents)
    lines = contents.to_s.lines
    lines.shift
    lines.shift

    sets = []

    while l = lines.shift
      if data_lines = l.match(/^(\d+)\n/) {|m| m[1].to_i}
        flights = []
        data_lines.times do
          lines.shift.match(/^([A-Z]+) ([A-Z]+) ([0-9\:]+) ([0-9\:]+) ([0-9\.]+)/) do |match|
            _, from, to, depart, arrive, price = match.to_a
            flights << Flight.new.set_data({
              from: from.to_sym,
              to: to.to_sym,
              depart: DateTime.parse(depart),
              arrive: DateTime.parse(arrive),
              price: BigDecimal(price)
            })
          end
        end

        sets << FlightSet.new(flights)
      end
    end

    sets
  end

end
