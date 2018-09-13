require 'savon'
require 'nokogiri'

module EstonianEInvoice
  module Providers
    class Omniva
      def initialize(soap_client:, secret_key:)
        @soap_client = soap_client
        @secret_key = secret_key
      end

      def deliver(e_invoice)
        message = normalize_e_invoice_xml(e_invoice.generate)
        soap_client.call(:e_invoice, attributes: { authPhrase: secret_key }, message: message)
      end

      private

      attr_reader :soap_client
      attr_reader :secret_key

      def normalize_e_invoice_xml(xml)
        xml_doc = Nokogiri.XML(xml)
        xml_doc.root.to_s
      end
    end
  end
end