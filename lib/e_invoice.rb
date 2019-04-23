require 'builder'
require 'date'
require 'e_invoice/version'
require 'e_invoice/e_invoice'
require 'e_invoice/seller'
require 'e_invoice/buyer'
require 'e_invoice/beneficiary'
require 'e_invoice/invoice'
require 'e_invoice/invoice_item'
require 'e_invoice/vat/vat'
require 'e_invoice/vat/no_vat'
require 'e_invoice/generator'
require 'e_invoice/config'
require 'e_invoice/providers/omniva'

module EInvoice
  def self.provider=(provider)
    @provider = provider
  end

  def self.provider
    @provider
  end
end
