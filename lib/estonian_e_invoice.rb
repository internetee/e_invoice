require 'builder'
require 'date'
require 'estonian_e_invoice/version'
require 'estonian_e_invoice/e_invoice'
require 'estonian_e_invoice/seller'
require 'estonian_e_invoice/buyer'
require 'estonian_e_invoice/beneficiary'
require 'estonian_e_invoice/invoice'
require 'estonian_e_invoice/invoice_item'
require 'estonian_e_invoice/vat/vat'
require 'estonian_e_invoice/vat/no_vat'
require 'estonian_e_invoice/generator'
require 'estonian_e_invoice/config'
require 'estonian_e_invoice/providers/omniva'

module EstonianEInvoice
  def self.provider=(provider)
    @provider = provider
  end

  def self.provider
    @provider
  end
end
