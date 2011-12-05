require "bundler/gem_tasks"
require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
require 'data_mapper/validations/i18n/version'
Rake::RDocTask.new do |rdoc|
  version = DataMapper::Validations::I18n::VERSION
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-validations-i18n #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
