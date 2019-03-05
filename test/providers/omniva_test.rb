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
  #include ProviderInterfaceTest

  def setup
    #@object = EstonianEInvoice::Providers::Omniva.new
  end

  def test_sends_e_invoice_to_service_provider
    stub_wsdl_request

    provider = EstonianEInvoice::Providers::Omniva.new
    provider.deliver(EInvoiceDouble.new)

    #   soap_client = Minitest::Mock.new
    #   soap_client.expect(:call, true, [:e_invoice, { :attributes => { authPhrase: 'test-key' },
    #                                                  message: '<E_Invoice/>' }])
    #   provider = EstonianEInvoice::Providers::Omniva.new(soap_client: soap_client,
    #                                                      secret_key: 'test-key')
    #   provider.deliver(EInvoiceDouble.new)
    #   soap_client.verify
    # end
  end

  private

  def stub_wsdl_request
    response_body = File.read('test/fixtures/wsdl.xml')
    stub_request(:get, 'https://finance.omniva.eu/finance/erp/erpServices.wsdl').to_return(status: 200,
                                                                                           body: response_body)
  end

  def stub_main_request
    stub_request(:post, "https://testfinance.post.ee/finance/erp/").
      with(
        body: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://e-arvetekeskus.eu/erp\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ins0=\"http://www.pangaliit.ee/arveldused/e-arve/\"><env:Body><tns:EInvoiceRequest authPhrase=\"test-api-key\"><E_Invoice/></tns:EInvoiceRequest></env:Body></env:Envelope>")
      .to_return(status: 200)
  end
end