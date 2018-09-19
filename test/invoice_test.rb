require 'test_helper'
require_relative 'invoice_item_interface_test'

class InvoiceItemDouble
  include InvoiceItemInterfaceTest

  def amount
    Money.from_amount(5)
  end
end

class InvoiceTest < Minitest::Test
  def test_calculate_total
    invoice = EstonianEInvoice::Invoice.new(seller: 'any',
                                            buyer: 'any',
                                            beneficiary: 'any',
                                            items: [InvoiceItemDouble.new, InvoiceItemDouble.new])
    assert_equal Money.from_amount(10), invoice.total
  end
end