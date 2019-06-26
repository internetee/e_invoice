require 'test_helper'

class InvoiceTest < Minitest::Test
  def test_aliases_id_to_number
    invoice = EInvoice::Invoice.new
    invoice.number = 'inv001'

    assert_equal 'inv001', invoice.id
  end

  def test_valid_delivery_channels
    assert_equal %i[internet_bank portal], EInvoice::Invoice.valid_delivery_channels
  end

  def test_sets_single_delivery_channel
    delivery_channel = :internet_bank

    invoice = EInvoice::Invoice.new
    invoice.delivery_channel = delivery_channel

    assert_equal [delivery_channel], invoice.delivery_channel
  end

  def test_sets_multiple_delivery_channels
    delivery_channel = %i(internet_bank portal)

    invoice = EInvoice::Invoice.new
    invoice.delivery_channel = delivery_channel

    assert_equal delivery_channel, invoice.delivery_channel
  end

  def test_invalid_delivery_channel
    invoice = EInvoice::Invoice.new
    e = assert_raises ArgumentError do
      invoice.delivery_channel = %i[internet_bank invalid]
    end
    error_message = 'Delivery channel "invalid" is invalid. Valid channels are:' \
                    ' [:internet_bank, :portal]'
    assert_equal error_message, e.message
  end
end