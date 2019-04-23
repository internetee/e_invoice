module EInvoice
  module VAT
    class NoVAT
      def type
        'NOTTAX'
      end

      def rate
        0
      end

      def amount
        0
      end
    end
  end
end
