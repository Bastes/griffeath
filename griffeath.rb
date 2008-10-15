require 'circular_state_map.rb'

=begin rdoc
:include: README
=end
class Griffeath < CircularStateMap
  def initialize(states = 4)
    super (0..(states - 1))
  end
  
  def evolve!
    result = Hash.new
    @cells.each do |pos, value|
      around pos, true do |cpos|
        unless result.has_key? cpos
          result[cpos] = eval_next cpos
        end
      end
    end
    @cells = result
  end
  
  def values_around(pos, &block)
    around pos do |cpos|
      yield self[cpos]
    end
  end
  
  def eval_next(pos)
    former_value = self[pos]
    next_value = next_state(former_value)
    value_count = 0
    values_around pos do |value|
      value_count += 1 if value == next_value
    end
    value == 3 ? next_value : former_value
  end
  
  def state(value)
    value.to_i % @states
  end
  
  def next_state(value)
    state(value.to_i.next)
  end

  def each(bounds = {})
    
  end
end

