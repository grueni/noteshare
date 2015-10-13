require 'rake'
require 'rake/testtask'

# https://mallibone.wordpress.com/tag/raketesttask/

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.libs    << 'spec'
end

task default: :test
task spec: :test
