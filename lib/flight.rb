Flight = Struct.new(:from, :to, :depart, :arrive, :price) do

  def set_data(data = {})
    members.each do |member|
      self[member] = data.fetch(member) { :"no_#{member}" }
    end
    self
  end

  def connections(flights)
    flights.select { |f2| to == f2.from && arrive < f2.depart }
  end

  def connects?(destination, flights)
    to == destination || connections(flights).any? { |c| c.connects?(destination, flights) }
  end

end
