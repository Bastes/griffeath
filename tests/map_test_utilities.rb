module Griffeath
  module MapTestUtilities
    # creates a set of points
    def square(range = nil)
      range ||= (-5..5)
      @square ||= Hash.new
      @square[range] ||= range.to_a.collect { |i| range.to_a }
    end
  
    # circles through a square set of points
    def points(range = nil, &block)
      s = square(range)
      s.each_index do |x|
        s[x].each do |y|
          yield x, y 
        end
      end
    end
    
    # fills a new map with a square set of test values
    def filled_map(range = nil)
      map = Map.new
      points(range) { |x, y| map[x, y] = anything(x, y) }
      map
    end
    
    # a basic value based on x, y coordinates to fill a map and perform checks
    def anything(x, y)
      "#{x} - #{y}"
    end
  end
end

