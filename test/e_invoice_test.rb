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

  def test_delivers_to_provider
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    provider = Minitest::Mock.new
    provider.expect(:deliver, nil, [e_invoice])

    e_invoice.deliver(provider)

    provider.verify
  end

  def test_generates_xml
    expected_xml = 'xml'
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    generator = Minitest::Mock.new
    generator.expect(:generate, expected_xml, [e_invoice])

    xml = e_invoice.to_xml(generator)

    assert_equal expected_xml, xml
  end

  def test_returns_invoice_count
    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: 'any')
    assert_equal 1, e_invoice.invoice_count
  end

  def test_calculates_total_amount_of_all_invoices
    invoice_total = 10
    invoice = EInvoice::Invoice.new
    invoice.total = invoice_total

    e_invoice = EInvoice::EInvoice.new(date: Date.today, invoice: invoice)

    assert_equal invoice_total, e_invoice.total_amount
  end
end