module EInvoice
  class Buyer < InvoiceParty
    attr_accessor :email, :bank_account
  end
end