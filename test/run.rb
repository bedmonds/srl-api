gem 'simplecov'
gem 'minitest'
require 'simplecov'
SimpleCov.command_name('run')
SimpleCov.start

require 'minitest/autorun'
require 'minitest/hooks/default'

if Gem::Specification.find_all_by_name('minitest-color').any?
  require 'minitest/color' 
end

Dir["test/run/**/*_test.rb"].each do |f|
  require File.expand_path(f)
end
