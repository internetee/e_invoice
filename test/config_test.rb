require 'test_helper'

class ConfigTest < Minitest::Test
  def test_sets_provider
    provider = :some
    EInvoice.provider = provider
    assert_equal provider, EInvoice.provider
  end
end