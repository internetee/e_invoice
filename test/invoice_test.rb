require 'test_helper'
require_relative 'amountable_interface_test'

class InvoiceItemDouble
  def amount
    Money.from_amount(5)
  end
end

class InvoiceItemDoubleTest < Minitest::Test
  include AmountableInterfaceTest

  def setup
    @object = InvoiceItemDouble.new
  end
end

class InvoiceTest < Minitest::Test
  def test_calculates_total
    invoice = EstonianEInvoice::Invoice.new(seller: 'any',
                                            buyer: 'any',
                                            beneficiary: 'any',
                                            items: [InvoiceItemDouble.new, InvoiceItemDouble.new])
    assert_equal Money.from_amount(10), invoice.total
  end
end