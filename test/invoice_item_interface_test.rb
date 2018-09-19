module InvoiceItemInterfaceTest
  def test_implement_invoice_item_interface
    assert_respond_to @object, :amount
  end
end