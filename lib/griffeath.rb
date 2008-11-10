require 'lib/circular_state_map'

module Griffeath # :nodoc:
  class Griffeath < CircularStateMap
    def initialize(states = [0, 1, 2, 3], values = [])
      super
    end

    def evolution!
      result = {}
      @cells.each do |pos, value|
        x, y = coordinates(pos)
        around(x, y, true) do |v, x, y|
          cpos = position(x, y)
          unless result.has_key? cpos 
            result[cpos] = eval_next(x, y) 
          end
        end
      end
      result.delete_if { |k, v| v == states.state }
      @cells = result
      self
    end
    
    def eval_next(x, y)
      former_value = self[x, y]
      next_value = states.next(former_value)
      value_count = 0
      around(x, y) do |v, x, y|
        value_count += 1 if v == next_value
      end
      value_count >= 3 ? next_value : former_value
    end
  end
end

