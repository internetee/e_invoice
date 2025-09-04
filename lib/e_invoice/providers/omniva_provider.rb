require 'logger'

module EInvoice
  module Providers
    class OmnivaProvider
      attr_reader :config, :soap_client, :logger

      def initialize(provider_config_user, logger = nil)
        @config = OpenStruct.new(provider_config.merge(provider_config_user))
        @soap_client = Savon.client(wsdl: wsdl)
        @logger = logger || Logger.new($stdout)
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
        logger.info("[OmnivaProvider] Sending e-invoice with message: #{message}")
        logger.info("[OmnivaProvider] SOAP attributes: #{soap_attributes}")
        response = soap_client.call(soap_operation, attributes: soap_attributes, message: message)
        logger.info("[OmnivaProvider] Received response: #{response.body}")
        response
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

      def provider_config
        config_file = Pathname(__dir__).join('omniva/config.yml')
        YAML.load_file(config_file)
      end
    end
  end
end