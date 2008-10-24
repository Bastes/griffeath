require 'lib/state_map'
require 'test/unit'
require 'tests/map_test_utilities'

module Griffeath
  class StateMapTest < Test::Unit::TestCase
    include MapTestUtilities
    
    # the states list should be kept safe and not accessed directly
    def test_keep_states_safe
      map = StateMap.new [:empty, :full]
      assert_raise(TypeError) { map.states[0] = :something }
      assert_raise(NoMethodError) { map.states = :truc }
    end
  
    # an empty map should only contain the empty value (first in the value array)
    def test_empty_state
      map = StateMap.new [:empty, :full]
      points do |x, y|
        assert_equal map[x, y], :empty
      end
    end
    
    # an element out of state should be kept as the nil state
    def out_of_states_elements
      map = StateMap.new [:empty, :full]
      assert_equal     map.state(:empty),          :empty
      assert_not_equal map.state(:something_else), :something_else
      assert_equal     map.state(:something_else), :empty
      assert_equal     map.state(:full),           :full
      points do |x, y|
        someotherthing = map[x, y] = something = anything(x, y)
        [someotherthing, map[x, y]].each do |state|
          assert_not_equal state, something 
          assert_equal     state, :empty
        end
      end
    end
  end
end

