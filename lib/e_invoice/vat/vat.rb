module EInvoice
  module VAT
    class VAT
      attr_accessor :rate
      attr_accessor :amount

      def initialize(rate:, amount:)
        @rate = rate
        @amount = amount
      end

      def type
        'TAX'
      end
    end
  end
end
