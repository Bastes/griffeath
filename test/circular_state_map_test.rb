require 'test/unit'
require 'test/map_test_utilities'
require 'griffeath/circular_state_map'

module Griffeath
  class CircularStateMapTest < Test::Unit::TestCase
    include MapTestUtilities
    
    # the states list should be kept safe and unchanged
    def test_keep_states_safe
      map = CircularStateMap.new [:empty, :full]
      assert_raise(TypeError) { map.states[0] = :something }
      assert_raise(NoMethodError) { map.states = :truc }
    end
  
    # an empty map should only contain the default state
    # (first in the state array)
    def test_empty_state
      map = CircularStateMap.new [:empty, :full]
      points do |x, y|
        assert_equal map[x, y], :empty
      end
    end
    
    # an element out of state should not be allowed to pollute the map
    def test_out_of_states_elements
      map = CircularStateMap.new [:empty, :full]
      points do |x, y|
        assert_raise ArgumentError do
          map[x, y] = anything(x, y)
        end
      end
    end

    # a cell evolving should go to next state in the cycle
    def test_evolving
      map = CircularStateMap.new [0, 1, 2]
      states = [1, 2, 0]
      points do |x, y|
        states .each do |state|
          previous_state = map[x, y]
          assert_equal state, map.evolve(x, y)
          assert_equal previous_state, map[x, y]
          assert_equal state, map.evolve!(x, y)
          assert_equal state, map[x, y]
        end
      end
    end
    
    # comparing values with different sets of states should return false
    def test_comparison
      map = CircularStateMap.new [0, 1, 2]
      assert_equal map, [[0, 0, 0]]
      assert_not_equal map, [[:lorem, :ipsum, :dolor]]
      assert_not_equal map, [['fithos', 'lusec', 'vitos']]
      assert_not_equal map, [[5, 7, 9]]
    end
  end
end
