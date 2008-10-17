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
  
  # executes given block for each cell of a portion of the map
  # x1, y1, x2, y2:: coordinates of the zone to extract
  def zone(x1, y1, x2, y2, &block)
    xmin, xmax = [x1, x2].sort
    ymin, ymax = [y1, y2].sort
    (ymin..ymax).each do |y|
      (xmin..xmax).each do |x|
		yield self[x, y], x, y
	  end
	end
  end

  # executes given block for each neighbor cell of given position
  # x, y:: coordinates of the cell (integer)
  # including:: if true, given cell is included in the iteration (boolean) 
  def around(x, y, including = false, &block)
    zone(x - 1, y - 1, x + 1, y + 1) do |content, cx, cy|
	  yield content, cx, cy if including or  cx != x or cy != y
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

