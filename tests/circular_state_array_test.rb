require 'test/unit'
require 'lib/circular_state_array'

module Griffeath
  class CircularStateArrayTest < Test::Unit::TestCase
    # should require at least 2 different states value
    def test_states_required
      assert_raise(ArgumentError) { CircularStateArray.new() }
      assert_raise(ArgumentError) { CircularStateArray.new(0) }
      assert_raise(ArgumentError) { CircularStateArray.new(0, 0) }
      assert_raise(ArgumentError) { CircularStateArray.new([]) }
      assert_raise(ArgumentError) { CircularStateArray.new([0]) }
      assert_raise(ArgumentError) { CircularStateArray.new([0, 0]) }
      assert_nothing_raised { CircularStateArray.new(0, 1) }
      assert_nothing_raised { CircularStateArray.new(0, 1, 0) }
      assert_nothing_raised { CircularStateArray.new([0, 1]) }
      assert_nothing_raised { CircularStateArray.new([0, 1, 0]) }
    end

    # should store individual states ordered
    def test_states_order
      a = CircularStateArray.new(0, 1, 2, 0, 1, 3, 2, 1)
      assert_equal a.to_a, [0, 1, 2, 3]
    end
    
    # should keep the first value as the default state
    def test_state_default
      a = CircularStateArray.new(:first, :other)
      assert_equal :first, a.default
      assert_equal :first, a.state   
      assert_equal :first, a.state(:unknown)
      assert_equal :first, a.state(:first)
      assert_equal :other, a.state(:other)
    end
  end
end
