module EInvoice
  module Providers
    class TestProvider
      @@deliveries = []

      def self.deliveries
        @@deliveries
      end

      def deliver(_e_invoice)
        @@deliveries << _e_invoice
      end
    end
  end
end