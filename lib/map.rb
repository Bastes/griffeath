=begin rdoc
=Simple "infinite" planar map.

* a map has no boundaries
* x stands for column, y for row
* iterations goes rows by rows, then column by column
* empty cells holds nil

=end
module Griffeath # :nodoc:
  class Map
    # values:: pre-set in an array of arrays, hash of hash, or another map
    def initialize(values = nil)
      @cells = Hash.new
      if values
        begin
          if values.class == self.class
            values.each { |content, x, y| self[x, y] = content }
          elsif values.respond_to? :each_index
            values.each_index do |y|
              values[y].each_index do |x|
                self[x, y] = values[y][x]
              end
            end
          elsif values.respond_to? :each_pair
            values.each_pair do |y, row|
              row.each_pair do |x, content|
                self[x, y] = values[y][x]
              end
            end
          else
            raise ArgumentError.new
          end
        rescue
          raise ArgumentError.new("Given values are not in a proper array or hash.")
        end
      end
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
    
    # executes given block for each non-empty cell of the map
    def each(&block) # :yields: content, x, y
      @cells.each do |key, value|
        x, y = coordinates(key)
        yield value, x, y
      end
    end

    # executes given block for each cell of a portion of the map
    # x1, y1, x2, y2:: coordinates of the zone to extract
    def zone(x1, y1, x2, y2, &block) # :yields: content, x, y
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
    def around(x, y, including = false, &block) # :yields: content, x, y
      zone(x - 1, y - 1, x + 1, y + 1) do |content, cx, cy|
        yield content, cx, cy if including or  cx != x or cy != y
      end
    end
    
    # checks wether given value contains exactly the same pattern as this map
    # value can be :
    # - an array of arrays [row][column]
    # - a hash of hashes (integer keys) [row][column]
    # - another map
    # the position and orientation of the pattern are relevant
    # value:: value compared to this map
    def ==(value)
      return true if self.eql? value
      begin
        return self.eql?(self.class.new(value))
      rescue
        return false
      end
    end
    
    # checks wether given other map is equivalent to this one
    # value:: value compared to this map
    def eql?(value)
      return false unless self.class == value.class
      tag_cells = @cells.clone
      value.each do |content, x, y|
        return false unless tag_cells.delete(position(x, y))
      end
      return tag_cells.empty?
    end

    private
    
    def position(x, y) # :nodoc:
      "#{x}_#{y}".to_sym
    end
    
    def coordinates(pos) # :nodoc:
      pos.to_s.split('_').collect! { |i| i.to_i  }
    end
  end
end
