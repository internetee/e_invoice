module EInvoice
  module Providers
    class Omniva
      attr_reader :config
      attr_reader :soap_client

      def initialize(config)
        @config = OpenStruct.new(config)
        @soap_client = Savon.client(wsdl: wsdl)
      end

      def wsdl
        if test_mode?
          config.wsdl_test
        else
          config.wsdl_production
        end
      end

      def deliver(e_invoice)
        message = normalize_e_invoice_xml(e_invoice.to_xml)
        soap_client.call(soap_operation, attributes: soap_attributes, message: message)
      end

      private

      def soap_operation
        config.soap_operation.to_sym
      end

      def soap_attributes
        { authPhrase: config.password }
      end

      def test_mode?
        config.test_mode
      end

      def normalize_e_invoice_xml(xml)
        xml_doc = Nokogiri.XML(xml)
        xml_doc.root.to_s
      end
    end
  end
end