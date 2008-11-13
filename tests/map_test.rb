require 'test/unit'
require 'tests/map_test_utilities'
require 'lib/map'

module Griffeath
  class MapTest < Test::Unit::TestCase
    include MapTestUtilities
  
    # an empty map should only contain nil values
    def test_empty_map
      map = Map.new
      points { |x, y| assert_nil map[x, y] }
    end
    
    # creating a map from an array
    def test_importing_an_array
      array = filled_array
      map = Map.new(array)
      points(0..9) { |x, y| assert_equal array[y][x], map[x, y] }
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
    
    # iterating through all non-empty cells
    def test_each
      map = filled_map
      s = sequence(map)
      map.each do |v, x, y|
        assert_not_nil s.delete([x, y, v]), "Position (#{x}, #{y}) shouldn't be iterated and should be nil ('#{v}' found)."
      end
      assert_block "Should have iterated through #{s.length} more element(s) : #{s.collect { |e| "\n- (#{e[0]}, #{e[1]}) => '#{e[2]}'" }}" do
        s.empty?
      end
    end

    # iterating through a specific zone
    def test_zone
      map = filled_map
      s = sequence(map, -6..6)
      map.zone(-6, 6, 6, -6) do |v, x, y|
        sx, sy, sv = s.shift
        assert_equal x, sx
        assert_equal y, sy
        assert_equal v, sv
      end
    end
    
    # iterating around a specific spot
    def test_around
      map = filled_map
      s = sequence(map, -1..1)
      [true, false].each do |including|
        seq = s.clone
        map.around(0, 0, including) do |v, x, y|
          sx, sy, sv = seq.shift
          assert_equal x, sx
          assert_equal y, sy
          assert_equal v, sv
        end
        s.delete_at 4 if including
      end
      map.around(0, 0) do |v, x, y|
        sx, sy, sv = s.shift
        assert_equal x, sx
        assert_equal y, sy
        assert_equal v, sv
      end
    end
    
    # a map should be comparable to
    # - another map
    # - an array of arrays
    # - a hash of hashes (with integer coordinates)
    # as long as the filled area of the map corresponds to the comparison
    # pattern, both should be considered equal, disregarding the position of the
    # pattern
    def test_comparison
      map1 = filled_map
      
      # these clearly can't be equal
      assert_not_equal map1, nil
      assert_not_equal map1, 1
      assert_not_equal map1, "blah blah"

      # both maps are equal
      map2 = filled_map
      assert_equal map1, map2
      assert_equal map1.eql?(map2), true
      
      # unless they differ even in the slightest way
      map2[0, 0] = nil
      assert_not_equal map1, map2
      assert_not_equal map1.eql?(map2), true
      
      # comparing with an equivalent array
      map1 = Map.new(array = filled_array)
      assert_equal(map1, array)

      # comparing with different arrays, some ill-formatted
      assert_not_equal(map1, [])
      assert_not_equal(map1, [1])
      assert_not_equal(map1, [1, 2])
      assert_not_equal(map1, [[1], [2]])

      # comparing with an equivalent hash
      hash = {}
      points do |x, y|
        hash[y] ||= {}
        hash[y][x] = anything(x, y)
      end
      map1 = Map.new(hash)
      assert_equal(map1, hash)

      # comparing with different hashes, some ill-formatted
      assert_not_equal(map1, {})
      assert_not_equal(map1, {1 => 1})
      assert_not_equal(map1, {:a => 1})
      assert_not_equal(map1, {1 => 1, 2 => 2})
      assert_not_equal(map1, {:a => 1, :b => 2})
      assert_not_equal(map1, {1 => {1 => 1}, 2 => {2 => 2}})
      assert_not_equal(map1, {:a => {:a => 1}, :b => {:a => 2}})
    end
  end
end

