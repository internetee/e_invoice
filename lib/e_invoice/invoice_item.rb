module EInvoice
  class InvoiceItem
    attr_accessor :description
    attr_accessor :quantity
    attr_accessor :unit
    attr_accessor :price
    attr_accessor :subtotal
    attr_accessor :vat_rate
    attr_accessor :vat_amount
    attr_accessor :total
  end
end
