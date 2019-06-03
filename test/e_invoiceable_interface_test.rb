module EInvoiceableInterfaceTest
  def test_implements_the_e_invoiceable_interface
    assert_respond_to @object, :date
    assert_respond_to @object, :id
    assert_respond_to @object, :invoice
    assert_respond_to @object, :invoice_count
    assert_respond_to @object, :total_amount
  end
end