module EInvoice
  class Buyer < InvoiceParty
    attr_accessor :email
    attr_accessor :bank_account
  end
end