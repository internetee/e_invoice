if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'e_invoice'
require 'minitest/autorun'
require 'webmock/minitest'