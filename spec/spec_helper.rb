require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'
require 'bundler/setup'
require 'rg_codebreaker'
require 'codebreaker/console'

RSpec.configure do |config|
# config.filter_run_excluding statistic_test: true
end
