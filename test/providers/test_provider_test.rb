require 'test_helper'

class OmnivaProviderTest < Minitest::Test
  def test_accumulates_sent_e_invoices
    EInvoice::Providers::TestProvider.deliveries.clear
    e_invoice = 'e-invoice'

    provider = EInvoice::Providers::TestProvider.new
    provider.deliver(e_invoice)

    assert_equal 1, EInvoice::Providers::TestProvider.deliveries.count
  end
end