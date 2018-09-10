require 'test_helper'

class InvoiceTest < Minitest::Test
  def test_calculate_total
    item1 = EstonianEInvoice::InvoiceItem.new
    item2 = EstonianEInvoice::InvoiceItem.new
    items = [item1, item2]

    item1.stub(:amount, Money.from_amount(2.5)) do
      item2.stub(:amount, Money.from_amount(2.5)) do
        invoice = EstonianEInvoice::Invoice.new(nil, nil, nil, items)
        assert_equal Money.from_amount(5), invoice.total
      end
    end
  end
end