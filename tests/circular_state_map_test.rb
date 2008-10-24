require 'test/unit'
require 'tests/map_test_utilities'
require 'lib/circular_state_map'

module Griffeath
  class CircularStateMapTest < Test::Unit::TestCase
    include MapTestUtilities
    
    # the states list should be kept safe and unchanged
    def test_keep_states_safe
      map = CircularStateMap.new [:empty, :full]
      assert_raise(TypeError) { map.states[0] = :something }
      assert_raise(NoMethodError) { map.states = :truc }
    end
  
    # an empty map should only contain the default state (first in the state array)
    def test_empty_state
      map = CircularStateMap.new [:empty, :full]
      points do |x, y|
        assert_equal map[x, y], :empty
      end
    end
    
    # an element out of state should be kept at the default state
    def test_out_of_states_elements
      map = CircularStateMap.new [:empty, :full]
      points do |x, y|
        map[x, y] = something = anything(x, y)
        someotherthing = map[x, y]
        [someotherthing, map[x, y]].each do |state|
          assert_not_equal state, something 
          assert_equal     state, :empty
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
  end
end
