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
    def []=(x, y, content)
      content = @states.state(content) 
      super(x, y, content == @states.default ? nil : content)
      content
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
  end
end

