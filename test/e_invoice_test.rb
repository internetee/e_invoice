require 'test_helper'

class EInvoiceTest < Minitest::Test
  def test_returns_date
    date = Date.parse('2010-07-05')

    e_invoice = EInvoice::EInvoice.new(date: date, invoice: 'any')

    assert_equal date, e_invoice.date
  end

  def test_generates_random_id
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    another_e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')

    refute_empty e_invoice.id
    refute_equal e_invoice.id, another_e_invoice.id
  end

  def test_generates_xml
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    generator = Minitest::Mock.new
    generator.expect(:generate, 'xml', [e_invoice])

    xml = e_invoice.to_xml(generator)

    generator.verify
    assert_equal 'xml', xml
  end

  def test_returns_invoice_count
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    assert_equal 1, e_invoice.invoice_count
  end

  def test_calculates_total_amount
    invoice_total = 10
    invoice = EInvoice::Invoice.new
    invoice.total = invoice_total

    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: invoice)

    assert_equal invoice_total, e_invoice.total
  end
end