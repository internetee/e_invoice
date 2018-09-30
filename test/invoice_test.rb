require 'test_helper'

class InvoiceTest < Minitest::Test
  def test_aliases_id_to_number
    invoice = EstonianEInvoice::Invoice.new(seller: 'any',
                                            buyer: 'any',
                                            beneficiary: 'any',
                                            items: [])
    invoice.number = 'inv001'
    assert_equal 'inv001', invoice.id
  end
end
