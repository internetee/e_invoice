require 'test_helper'
require 'nokogiri'
require_relative 'e_invoiceable_interface_test'

class EInvoiceTest < Minitest::Test
  include EInvoiceableInterfaceTest

  def setup
    @e_invoice = @object = EstonianEInvoice::EInvoice.new
  end

  def test_default_date_is_today_date
    Date.stub(:today, Date.parse('2010-07-05')) do
      e_invoice = EstonianEInvoice::EInvoice.new
      assert_equal Date.parse('2010-07-05'), e_invoice.date
    end
  end

  def test_generates_checksum
    refute_empty @e_invoice.checksum
    assert @e_invoice.checksum.size <= 20, 'Checksum should be less than or equal to 20 chars'
  end

  def test_delegates_to_provider
    provider = Minitest::Mock.new
    provider.expect(:deliver, true, [@e_invoice])
    EstonianEInvoice.provider = provider

    @e_invoice.deliver
    provider.verify
  end

  def test_delegates_to_generator
    generator = Minitest::Mock.new
    generator.expect(:generate, true, [@e_invoice])

    @e_invoice.generate(generator)
    generator.verify
  end

  def test_invoice_count
    invoices = %i(invoice1 invoice2)
    e_invoice = EstonianEInvoice::EInvoice.new(invoices)
    assert_equal 2, e_invoice.invoice_count
  end

  def test_calculates_total_amount_of_all_invoices
    invoice = EstonianEInvoice::Invoice.new(seller: 'seller',
                                            buyer: 'buyer',
                                            beneficiary: 'beneficiary',
                                            items: 'items')
    invoice.stub(:total, 5) do
      invoices = [invoice, invoice.clone]
      e_invoice = EstonianEInvoice::EInvoice.new(invoices)
      assert_equal 10, e_invoice.total
    end
  end
end