require 'lib/map'
require 'test/unit'

class MapTest < Test::Unit::TestCase
  def test_empty_map
    map = Map.new
	(-5..5).each do |x|
	  (-5..5).each do |y|
	    assert_nil map[x,y]
	  end
	end
  end
end
