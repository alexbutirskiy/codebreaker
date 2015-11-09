require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'byebug'

require 'rspec'
require 'bundler/setup'
require 'codebreaker'

RSpec.configure do |config|
#  config.filter_run_excluding statistic_test: true
end
