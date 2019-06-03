require 'builder'
require 'date'
require 'ostruct'

require 'nokogiri'
require 'savon'

require 'e_invoice/version'
require 'e_invoice/e_invoice'
require 'e_invoice/seller'
require 'e_invoice/buyer'
require 'e_invoice/bank_account'
require 'e_invoice/invoice'
require 'e_invoice/invoice_item'
require 'e_invoice/generator'
require 'e_invoice/config'
require 'e_invoice/providers/omniva_provider'
require 'e_invoice/providers/test_provider'

module EInvoice
  class << self
    attr_accessor :provider
  end
end