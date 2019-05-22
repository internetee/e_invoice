require 'test_helper'

class EInvoiceDouble
  def to_xml
    <<-XML
      <?xml version="1.0" encoding="utf-8"?>
      <E_Invoice></E_Invoice>
    XML
  end
end

class EInvoiceDoubleTest < Minitest::Test
  def test_implements_to_xml_interface
    assert_respond_to EInvoiceDouble.new, :to_xml
  end
end

class OmnivaProviderTest < Minitest::Test
  def test_delivers_normalized_e_invoice
    response_body = File.read('test/fixtures/omniva_wsdl.xml')
    wsdl_request = stub_request(:get, 'https://provider.test/wsdl.xml')
                     .to_return(status: 200, body: response_body)

    main_request = stub_request(:post, "https://provider.test/endpoint")
                     .with(body: main_request_body)
                     .to_return(status: 200, body: '')

    provider = EInvoice::Providers::Omniva.new(wsdl_production: 'https://provider.test/wsdl.xml',
                                               soap_operation: 'e_invoice',
                                               password: 'test-password',
                                               test_mode: false)
    provider.deliver(EInvoiceDouble.new)

    assert_requested wsdl_request
    assert_requested main_request
  end

  def test_uses_test_wsdl_when_test_mode_is_on
    provider = EInvoice::Providers::Omniva.new(test_mode: true, wsdl_test: 'wsdl-test')
    assert_equal 'wsdl-test', provider.wsdl
  end

  def test_uses_production_wsdl_when_test_mode_is_off
    provider = EInvoice::Providers::Omniva.new(test_mode: false, wsdl_production: 'wsdl-production')
    assert_equal 'wsdl-production', provider.wsdl
  end

  private

  def main_request_body
    '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://e-arvetekeskus.eu/erp" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ins0="http://www.pangaliit.ee/arveldused/e-arve/"><env:Body><tns:EInvoiceRequest authPhrase="test-password"><E_Invoice/></tns:EInvoiceRequest></env:Body></env:Envelope>'
  end
end