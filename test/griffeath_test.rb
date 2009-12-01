require 'test/unit'
require 'yaml'
require 'griffeath/griffeath'

module Griffeath
  class GriffeathTest < Test::Unit::TestCase
    # a new map should have 4 states by default
    def test_default_states
      assert_equal Griffeath.new.states, [ 0, 1, 2, 3 ]
    end
    
    # the map evolving should follow griffeath's rules
    def test_evolution
      tests = YAML::load(File.open('test/fixtures/griffeath_fixtures.yaml'))
      tests.each_pair do |rule_name, rule|
        states = (0..(rule['states'] - 1)).to_a
        rule['situations'].each_pair do |situation_name, situation|
          situation.each_pair do |exemple_name, exemple|
            map = Griffeath.new(states, exemple.shift)
            exemple.each do |e|
              map.evolution!
              assert_equal map, e
            end
          end
        end
      end
      #flunk "Finish writing this test."
    end
  end
end
 
