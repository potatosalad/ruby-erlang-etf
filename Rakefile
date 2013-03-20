require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "yard"

YARD::Rake::YardocTask.new(:doc)

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec]
