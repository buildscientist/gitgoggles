#!/usr/bin/env rake
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

task :run do |args|
  `ruby -I lib bin/git-goggles -R /tmp/git_goggles/`
end
