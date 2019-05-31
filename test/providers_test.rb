require 'test_helper'

module EInvoice
  module Providers
    class Test
      def initialize(config); end
    end
  end
end

class ProvidersTest < Minitest::Test
  def test_lookups_provider
    assert_kind_of EInvoice::Providers::Test, EInvoice::Providers.lookup('test', { foo: 'bar' })
  end
end