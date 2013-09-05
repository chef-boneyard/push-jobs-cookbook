#!/usr/bin/env rake
require 'rubocop/rake_task'
require 'foodcritic'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
desc 'Runs rspec tests'
task :test => :spec

desc 'Runs foodcritic linter'
task :foodcritic do
  if Gem::Version.new('1.9.2') <= Gem::Version.new(RUBY_VERSION.dup)
    FoodCritic::Rake::LintTask.new do |t|
      t.options = { :fail_tags => ['any'] }
    end
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

desc 'Runs Rubocop linter.'
task :rubocop do
  Rubocop::RakeTask.new
end

# Rubocop before rspec so we don't Rubocop vendored cookbooks
task :default => %w{rubocop foodcritic test}
