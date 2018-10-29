require 'test_helper'

class NoVATTest < Minitest::Test
  def setup
    @vat = EstonianEInvoice::VAT::NoVAT.new
  end

  def test_returns_type
    assert_equal 'NOTTAX', @vat.type
  end

  def test_returns_zero_rate
    assert @vat.rate.zero?
  end

  def test_returns_zero_amount
    assert @vat.amount.zero?
  end
end
