module EstonianEInvoice
  class EInvoice
    attr_reader :date
    attr_reader :checksum
    attr_reader :invoices

    def initialize(invoices = [])
      @date = Date.today
      @checksum = generate_checksum
      @invoices = invoices
    end

    def deliver(provider = EstonianEInvoice.provider)
      provider.deliver(self)
    end

    def generate(generator = Generator.new)
      generator.generate(self)
    end

    def invoice_count
      invoices.size
    end

    def total
      invoices.sum(&:total)
    end

    private

    def generate_checksum
      SecureRandom.hex[0...20]
    end
  end
end