=begin rdoc
:include: README
=end

=begin rdoc
=Simple "infinite" planar map.
=end
class Map

  def initialize # :nodoc:
    @cells = Hash.new
  end
  
  # returns a cell's content
  # x, y:: coordinates of the cell (integer) 
  def [](x, y)
    pos = position(x, y)
    @cells.has_key?(pos) ? @cells[pos] : nil
  end
  
  # sets a cell's content
  # x, y:: coordinates of the cell (integer) 
  # content:: content of the cell
  def []=(x, y, content)
	pos = position(x, y)
    @cells[pos]= content if content
	@cells.delete(pos) unless content
	content
  end
  
  # executes given block for each cell around given position
  # x, y:: coordinates of the cell (integer)
  # including:: if true, given cell is included in the iteration (boolean) 
  def around(x, y, including = false, &block)
    ((x - 1)..(x + 1)).each do |cx|
      ((y - 1)..(y + 1)).each do |cy|
        yield position(cx, cy) if including or  cx != x or cy != y
      end
    end
  end
    
  private
  
  def position(x, y) # :nodoc:
    "#{x}_#{y}".to_sym
  end
  
  def coordinates(pos) # :nodoc:
    pos.to_s.split('_').collect! { |i| i.to_i  }
  end
end

=begin rdoc
=Infinite 2D map specialized for handling a finite range of states in its cells.
=end
class StateMap < Map
  
  # states:: list of states a cell can take (the first will be the empty state)
  def initialize(states)
	@states = states.to_a.uniq
  end
  
  # returns the empty state
  def nil_state
	@states.first
  end
  
  # returns given content if it is in the states list or else the nil state
  # content:: content to return if possible
  def state(content)
    @states.include?(content) ? content : nil_state
  end
  
  # see Map::[]
  # see state
  def [](x, y)
    state super
  end
 
  # see Map::[]=
  # see state
  def []=(x, y, content)
	super(x, y, (content = state content) == nil_state ? nil : content)
	content
  end
end

=begin rdoc
=State map specialized for handling circular state lists.
=end
class CircularStateMap < StateMap
  # returns the next state of given state following the states sequence
  # (a value not present in the state list is equaled to the nil state)
  # value:: previous state
  def next_state(value)
    @states[@states.index(state value) + 1 % @states.length]
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

