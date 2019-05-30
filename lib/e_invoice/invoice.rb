module EInvoice
  class Invoice
    attr_accessor :seller
    attr_accessor :buyer
    attr_accessor :items

    attr_accessor :number
    alias_method :id, :number

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
  end
end