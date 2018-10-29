require 'test_helper'

class NoVATTest < Minitest::Test
  def test_returns_type
    vat = EstonianEInvoice::VAT::NoVAT.new
    assert_equal 'NOTTAX', vat.type
  end
end
