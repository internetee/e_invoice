module EstonianEInvoice
  class Invoice
    attr_accessor :number
    attr_accessor :date
    attr_accessor :recipient_id_code
    attr_accessor :reference_number
    attr_accessor :due_date
    attr_accessor :payer_name
    attr_accessor :currency

    attr_reader :seller
    attr_reader :buyer
    attr_reader :beneficiary
    attr_reader :items

    alias_method :id, :number

    def initialize(seller:, buyer:, beneficiary:, items:)
      @seller = seller
      @buyer = buyer
      @beneficiary = beneficiary
      @items = items
    end

    def total
      items.sum(&:amount)
    end
  end
end