module EInvoice
  class Invoice
    attr_accessor :number
    attr_accessor :date
    attr_accessor :recipient_id_code
    attr_accessor :reference_number
    attr_accessor :due_date
    attr_accessor :payer_name
    attr_accessor :beneficiary_name
    attr_accessor :beneficiary_account_number
    attr_accessor :subtotal
    attr_accessor :vat_amount
    attr_accessor :total
    attr_accessor :currency

    attr_reader :seller
    attr_reader :buyer
    attr_reader :items

    alias_method :id, :number

    def initialize(seller:, buyer:, items:)
      @seller = seller
      @buyer = buyer
      @items = items
    end
  end
end