require 'rake'
require 'rake/testtask'

task :default => [:test_units]

desc "Run basic tests"
Rake::TestTask.new("test_units") do |t|
  t.pattern = 'tests/*_test.rb'
  t.verbose = true
  t.warning = true
end