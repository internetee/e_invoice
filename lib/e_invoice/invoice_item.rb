module EInvoice
  class InvoiceItem
    attr_accessor :description, :quantity, :unit, :price,
                  :subtotal, :vat_rate, :vat_amount, :total
  end
end
