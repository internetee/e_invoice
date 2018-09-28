require 'test_helper'
require_relative 'amountable_interface_test'

class InvoiceItemDouble
  def amount
    5
  end
end

class InvoiceItemDoubleTest < Minitest::Test
  include AmountableInterfaceTest

  def setup
    @object = InvoiceItemDouble.new
  end
end

class InvoiceTest < Minitest::Test
  def test_aliases_id_to_number
    invoice = EstonianEInvoice::Invoice.new(seller: 'any',
                                            buyer: 'any',
                                            beneficiary: 'any',
                                            items: [])
    invoice.number = 'inv001'
    assert_equal 'inv001', invoice.id
  end

  def test_calculates_total
    invoice = EstonianEInvoice::Invoice.new(seller: 'any',
                                            buyer: 'any',
                                            beneficiary: 'any',
                                            items: [InvoiceItemDouble.new, InvoiceItemDouble.new])
    assert_equal 10, invoice.total
  end
end