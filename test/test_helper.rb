require 'pry'

if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'erlang-etf'

ENV['RANTLY_VERBOSE'] ||= '0'
require File.expand_path('../rantly_extensions', __FILE__)

require 'minitest/autorun'
require 'minitest/perf'
require 'minitest/reporters'
if ENV['SPEC']
  Minitest::Reporters.use!([
    Minitest::Reporters::SpecReporter.new
  ])
else
  Minitest::Reporters.use!
end
if ENV['FOCUS']
  require 'minitest/focus'
end
