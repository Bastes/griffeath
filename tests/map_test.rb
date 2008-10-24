require 'test/unit'
require 'tests/map_test_utilities'
require 'lib/map'

module Griffeath
  class MapTest < Test::Unit::TestCase
    include MapTestUtilities
  
    # an empty mao should only contain nil values
    def test_empty_map
      map = Map.new
      points { |x, y| assert_nil map[x, y] }
    end
    
    # putting something on a map should return that very thing
    def test_put_and_return_something
      map = Map.new
      points { |x, y| assert_equal(map[x, y] = anything(x, y), anything(x, y)) }
    end
  
    # something put on the map should stay wherever it's put
    def test_keep_things_put
      map = filled_map
      points { |x, y| assert_equal(map[x, y], anything(x, y)) }
    end
    
    # iterating through a specific zone
    def test_zone
      map = filled_map
      sequence = []
      (-6..6).each do |y|
        (-6..6).each do |x| 
          sequence << [x, y, map[x, y]]
        end
      end
      map.zone(-6, 6, 6, -6) do |v, x, y|
        sx, sy, sv = sequence.shift
        assert_equal x, sx
        assert_equal y, sy
        assert_equal v, sv
      end
    end
    
    # iterating around a specific spot
    def test_around
      map = filled_map
      sequence = []
      (-1..1).each do |y|
        (-1..1).each do |x| 
          sequence << [x, y, map[x, y]]
        end
      end
      [true, false].each do |including|
        seq = sequence.clone
        map.around(0, 0, including) do |v, x, y|
          sx, sy, sv = seq.shift
          assert_equal x, sx
          assert_equal y, sy
          assert_equal v, sv
        end
        sequence.delete_at 4 if including
      end
      map.around(0, 0) do |v, x, y|
        sx, sy, sv = sequence.shift
        assert_equal x, sx
        assert_equal y, sy
        assert_equal v, sv
      end
    end
  end
end

