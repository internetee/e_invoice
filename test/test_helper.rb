# SimpleCov is configured in .simplecov file
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'e_invoice'
require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/minitest'