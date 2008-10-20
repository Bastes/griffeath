require 'lib/map'

=begin rdoc
=Infinite 2D map specialized for handling a finite range of states in its cells.
=end
class StateMap < Map
  
  # creating a new state map
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

