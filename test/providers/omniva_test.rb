require 'test_helper'

class ProviderOmnivaTest < Minitest::Test
  def test_deliver_e_invoice_to_soap_web_service
    e_invoice_xml = <<~XML
      <?xml version="1.0" encoding="utf-8"?>
      <E_Invoice></E_Invoice>
    XML

    soap_client = Minitest::Mock.new
    e_invoice = EstonianEInvoice::EInvoice.new([])
    e_invoice.stub(:generate, e_invoice_xml) do
      soap_client.expect(:call, true, [:e_invoice, { :attributes => { authPhrase: 'test-key' },
                                                     message: '<E_Invoice/>' }])

      provider = EstonianEInvoice::Providers::Omniva.new(soap_client: soap_client,
                                                         secret_key: 'test-key')
      provider.deliver(e_invoice)

      soap_client.verify
    end
  end
end