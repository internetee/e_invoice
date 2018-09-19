module EstonianEInvoice
  class EInvoice
    attr_reader :date
    attr_reader :invoices

    def initialize(invoices = [])
      @date = Date.today
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
  end
end