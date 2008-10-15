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

