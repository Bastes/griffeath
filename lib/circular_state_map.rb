require 'lib/map'
require 'lib/circular_state_array'

=begin rdoc
=State map specialized for handling a circular list of state.
=end
module Griffeath # :nodoc:
  class CircularStateMap < Map
    attr_reader :states

    # creating a new state map
    # states:: list of states a cell can take (first state is default state)
    # values:: see Griffeath::Map#new
    def initialize(states, values = [])
      @states = CircularStateArray.new(states)
      @states.freeze
      super(values)
    end
    
    # see Map::[]
    # see CircularStateArray::state
    def [](x, y)
      @states.state super(x, y)
    end
   
    # see Map::[]=
    # see CircularStateArray::state
    # lenient:: set to true to avoid raising an argument error when the value is not a proper state
    def []=(x, y, content, lenient = false)
      raise ArgumentError.new("Unexpected value (#{content} for this map (allowed : #{@states.join(', ')})") unless lenient or @states.include?(content)
      content = @states.state(content) 
      super(x, y, content == @states.default ? nil : content)
    end
    
    # returns the next state of given position's cell
    # x, y:: coordinates of the cell (integer) 
    def evolve(x, y)
      @states.next self[x, y]
    end
    
    # evolves a cell to the next state and returns its new state
    # x, y:: coordinates of the cell (integer) 
    def evolve!(x, y)
      self[x, y] = evolve(x, y)
    end

    # see Map#==
    # specializes the behaviour to refuse out-of-states values
    def ==(value)
      return true if self.eql? value
      begin
        return self.eql?(self.class.new(self.states, value))
      rescue
        return false
      end
    end

    def inspect # :nodoc:
      super.gsub(/\(\(/, "@states : #{@states.join(', ')}\n  ((")
    end
  end
end

