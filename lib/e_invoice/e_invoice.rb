module EInvoice
  class EInvoice
    attr_reader :date
    attr_reader :invoice
    attr_reader :id

    def initialize(date:, invoice:)
      @date = date
      @invoice = invoice
      @id = generate_id
    end

    def deliver(provider = ::EInvoice.provider)
      provider.deliver(self)
    end

    def to_xml(generator = Generator.new)
      generator.generate(self)
    end

    def invoice_count
      1
    end

    def total
      invoice.total
    end

    private

    def generate_id
      SecureRandom.hex[0...20]
    end
  end
end