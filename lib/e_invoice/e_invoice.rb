module EInvoice
  class EInvoice
    attr_reader :date
    attr_reader :checksum
    attr_reader :invoice

    def initialize(date:, invoice:)
      @date = date
      @checksum = generate_checksum
      @invoice = invoice
    end

    def deliver(provider = ::EInvoice.provider)
      provider.deliver(self)
    end

    def generate(generator = Generator.new)
      generator.generate(self)
    end

    def invoice_count
      1
    end

    def total
      invoice.total
    end

    private

    def generate_checksum
      SecureRandom.hex[0...20]
    end
  end
end