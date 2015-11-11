require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => :spec
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = '--options .rspec_travis'
end
