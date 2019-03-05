require 'test_helper'

class ConfigTest < Minitest::Test
  def test_parses_config_file_for_a_given_environment
    config = EstonianEInvoice::Config.new(env: 'test', filename: 'test/fixtures/config.yml')
    assert_equal 'bar', config.foo
  end
end