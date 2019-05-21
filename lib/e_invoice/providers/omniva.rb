module EInvoice
  module Providers
    class Omniva
      attr_reader :config
      attr_reader :soap_client

      def initialize(user_config)
        @config = OpenStruct.new(user_config)
        @soap_client = Savon.client(wsdl: wsdl)
      end

      def test_mode?
        config.test_mode
      end

      def wsdl
        if test_mode?
          'https://testfinance.post.ee/finance/erp/erpServices.wsdl'
        else
          'https://finance.omniva.eu/finance/erp/erpServices.wsdl'
        end
      end

      def deliver(e_invoice)
        message = normalize_e_invoice_xml(e_invoice.to_xml)
        soap_client.call(:e_invoice, attributes: { authPhrase: config.password }, message: message)
      end

      private

      def normalize_e_invoice_xml(xml)
        xml_doc = Nokogiri.XML(xml)
        xml_doc.root.to_s
      end
    end
  end
end