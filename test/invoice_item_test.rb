require 'test_helper'
require_relative 'amountable_interface_test'

class InvoiceItemTest < Minitest::Test
  include AmountableInterfaceTest

  def setup
    @object = EstonianEInvoice::InvoiceItem.new
  end
end