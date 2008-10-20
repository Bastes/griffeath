module MapTestUtilities
  # creates a set of points
  def square
    @square ||= (-5..5).to_a.collect { |i| (-5..5).to_a }
  end

  # circles through a square set of points
  def points(&block)
    square.each_index do |x|
      square[x].each do |y|
        yield x, y 
      end
    end
  end
  
  # fills a new map with a square set of test values
  def filled_map
    map = Map.new
    points { |x, y| map[x, y] = anything(x, y) }
    map
  end
  
  # a basic value based on x, y coordinates to fill a map and perform checks
  def anything(x, y)
    "#{x} - #{y}"
  end
end

