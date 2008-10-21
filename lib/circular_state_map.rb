require 'lib/state_map'

=begin rdoc
=State map specialized for handling circular state lists.
=end
module Griffeath # :nodoc:
  class CircularStateMap < StateMap
    # returns the next state of given state following the states sequence
    # (a value not present in the state list is equaled to the nil state)
    # value:: previous state
    def next_state(value)
      @states[(@states.index(state(value)) + 1) % @states.length]
    end
    
    # returns the next state of given position's cell
    # x, y:: coordinates of the cell (integer) 
    def evolve_cell(x, y)
      next_state self[x, y]
    end
    
    # evolves a cell to the next state and returns its new state
    # x, y:: coordinates of the cell (integer) 
    def evolve_cell!(x, y)
      self[x, y] = sevolve_cell(x, y)
    end
  end
end

