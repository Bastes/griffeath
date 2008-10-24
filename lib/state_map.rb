require 'lib/map'
require 'lib/circular_state_array'

=begin rdoc
=Infinite 2D map specialized for handling a finite range of states in its cells.
=end
module Griffeath # :nodoc:
  class StateMap < Map
    attr_reader :states

    # creating a new state map
    # states:: list of states a cell can take (first state is default state)
    def initialize(states)
      super()
      @states = CircularStateArray.new(states)
      @states.freeze
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
  end
end

