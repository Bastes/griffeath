require 'lib/map'
require 'test/unit'

class MapTest < Test::Unit::TestCase
  # an empty mao should only contain nil values
  def test_empty_map
    map = Map.new
    points do |x, y|
      assert_nil map[x, y]
    end
  end
  
  # putting something on a map should return that very thing
  def test_put_and_return_something
    map = Map.new
    points { |x, y, v| assert_equal(map[x, y] = v, v) }
  end

  # something put on the map should stay wherever it's put
  def test_keep_things_put
    map = filled_map
    points { |x, y, v| assert_equal(map[x, y], v) }
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
  private
  
  # creates a set of points
  def square
    @square ||= (-5..5).to_a.collect { |i| (-5..5).to_a }
  end

  # circles through a square set of points
  def points(&block)
    square.each_index do |x|
      square[x].each do |y|
        yield x, y, "#{x} - #{y}"
      end
    end
  end
  
  # fills a new map with a square set of test values
  def filled_map
    map = Map.new
    points { |x, y, v| map[x, y] = v }
    map
  end
end
