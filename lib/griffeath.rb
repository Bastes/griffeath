require 'lib/circular_state_map'

class Griffeath < CircularStateMap
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
  
  def eval_next(pos)
    former_value = self[pos]
    next_value = next_state(former_value)
    value_count = 0
    values_around pos do |value|
      value_count += 1 if value == next_value
    end
    value == 3 ? next_value : former_value
  end
end

