=begin rdoc
=State map specialized for handling circular state lists.
=end
module Griffeath # :nodoc:
  class CircularStateArray < Array
    alias :default :first

    # a circular state array requires at least 2 values
    # values:: list of states
    def initialize(*values)
      values = values[0] if values.respond_to?(:length) and values.length == 1
      values = Array(values).uniq
      raise ArgumentError.new('Requires at least 2 different states.') unless values.length > 1
      super(values)
    end
    
    # returns given value if it is in the states array or the default if not
    # value:: value to check
    def state(value = nil)
      include?(value) ? value : default
    end
    
    # returns the state after given value
    # see state
    # value:: given value
    def next(value)
      self[(index(state(value)) + 1) % length]
    end
    
    # returns the state before given value
    # see state
    # value:: given value
    def previous(value)
      self[(index(state(value)) - 1) % length]
    end
  end
end

