require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => [:test,
                  :rdoc]

desc "Run tests"
Rake::TestTask.new do |t|
  t.pattern = 'tests/*_test.rb'
  t.verbose = true
  t.warning = true
end

desc "(Re-)Builds the documentation"
Rake::RDocTask.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
  rd.rdoc_dir = 'doc'
end

