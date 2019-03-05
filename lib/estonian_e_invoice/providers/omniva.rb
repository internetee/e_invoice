require 'savon'
require 'nokogiri'

module EstonianEInvoice
  module Providers
    class Omniva
      SOAP_OPERATION = :e_invoice
      private_constant :SOAP_OPERATION

      def initialize(config: EstonianEInvoice::Config.new(env: 'production', filename: 'lib/estonian_e_invoice/providers/omniva/config.yml'))
        @soap_client = Savon.client(wsdl: config.wsdl)
        @config = config
      end

      def deliver(e_invoice)
        message = normalize_e_invoice_xml(e_invoice.generate)
        soap_client.call(SOAP_OPERATION, attributes: { authPhrase: 'test' }, message: message)
      end

      private

      attr_reader :config
      attr_reader :soap_client

      def normalize_e_invoice_xml(xml)
        xml_doc = Nokogiri.XML(xml)
        xml_doc.root.to_s
      end
    end
  end
end