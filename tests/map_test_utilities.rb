module Griffeath
  module MapTestUtilities
    # circles through a square set of points
    def points(range = nil, &block)
      range ||= (-5..5)
      range.each do |y|
        range.each do |x|
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
    
    # fills a sequence with ordered values in a map
    def sequence(map, range = nil)
      s = []
      points(range) { |x, y| s << [x, y, map[x, y]] }
      s
    end
 
    # fills an array with test values
    def filled_array
      @array ||= Array.new(10) { |y| Array.new(10) { |x| anything(x, y) } }
    end
    
    # a basic value based on x, y coordinates to fill a map and perform checks
    def anything(x, y)
      "#{x} - #{y}"
    end
  end
end

