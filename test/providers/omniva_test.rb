require 'test_helper'
require_relative 'provider_interface_test'

class EInvoiceDouble
  def generate
    <<-XML
      <?xml version="1.0" encoding="utf-8"?>
      <E_Invoice></E_Invoice>
    XML
  end
end

class EInvoiceDoubleTest < Minitest::Test
  def test_implements_the_generatable_interface
    assert_respond_to EInvoiceDouble.new, :generate
  end
end

class ProviderOmnivaTest < Minitest::Test
  include ProviderInterfaceTest

  def setup
    @object = EstonianEInvoice::Providers::Omniva.new(soap_client: nil, secret_key: nil)
  end

  def test_delivers_normalized_e_invoice_xml_to_soap_web_service
    soap_client = Minitest::Mock.new
    soap_client.expect(:call, true, [:e_invoice, { :attributes => { authPhrase: 'test-key' },
                                                   message: '<E_Invoice/>' }])
    provider = EstonianEInvoice::Providers::Omniva.new(soap_client: soap_client,
                                                       secret_key: 'test-key')
    provider.deliver(EInvoiceDouble.new)
    soap_client.verify
  end
end