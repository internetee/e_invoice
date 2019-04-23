require 'test_helper'

class VATTest < Minitest::Test
  def test_returns_type
    vat = EInvoice::VAT::VAT.new(rate: 0, amount: 0)
    assert_equal 'TAX', vat.type
  end
end
