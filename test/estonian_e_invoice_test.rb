require "test_helper"

class EInvoiceTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::EInvoice::VERSION
  end
end