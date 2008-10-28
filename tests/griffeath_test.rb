require 'test/unit'
require 'yaml'
require 'lib/griffeath'

module Griffeath
  class CircularStateArrayTest < Test::Unit::TestCase
    # a new map should have 4 states by default
    def test_default_states
      # TODO
    end
    
    # the map evolving should follow griffeath's rules
    def test_evolution
      tests = YAML::load(File.open('tests/fixtures/griffeath_fixtures.yaml'))
      # TODO
    end
  end
end
 
