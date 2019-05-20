require 'test_helper'

class EInvoiceTest < Minitest::Test
  def setup
    @e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'invoice')
  end

  def test_returns_date
    date = Date.parse('2010-07-05')
    e_invoice = EInvoice::EInvoice.new(date: date, invoice: 'any')
    assert_equal date, e_invoice.date
  end

  def test_generates_checksum
    refute_empty @e_invoice.checksum
    assert @e_invoice.checksum.size <= 20, 'Checksum should be less than or equal to 20 chars'
  end

  def test_delegates_to_provider
    provider = Minitest::Mock.new
    provider.expect(:deliver, true, [@e_invoice])
    EInvoice.provider = provider

    @e_invoice.deliver
    provider.verify
  end

  def test_delegates_to_generator
    generator = Minitest::Mock.new
    generator.expect(:generate, true, [@e_invoice])

    @e_invoice.generate(generator)
    generator.verify
  end

  # Only one invoice is supported atm
  def test_invoice_count
    assert_equal 1, @e_invoice.invoice_count
  end

  def test_calculates_total_amount_of_all_invoices
    total = 10
    invoice = EInvoice::Invoice.new(seller: 'seller',
                                    buyer: 'buyer',
                                    beneficiary: 'beneficiary',
                                    items: 'items')
    invoice.stub(:total, total) do
      e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: invoice)
      assert_equal total, e_invoice.total
    end
  end
end