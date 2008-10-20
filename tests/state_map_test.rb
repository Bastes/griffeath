require 'lib/state_map'
require 'test/unit'
require 'tests/map_test_utilities'

class MapTest < Test::Unit::TestCase
  include MapTestUtilities

  # an empty mao should only contain nil values
  def test_empty_map
    map = Map.new
    points do |x, y|
      assert_nil map[x, y]
    end
  end
end
