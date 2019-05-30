require 'test_helper'

class InvoiceTest < Minitest::Test
  def test_aliases_id_to_number
    invoice = EInvoice::Invoice.new
    invoice.number = 'inv001'

    assert_equal 'inv001', invoice.id
  end
end