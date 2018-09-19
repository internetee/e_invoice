module EInvoiceableInterfaceTest
  def test_implements_the_e_invoiceable_interface
    assert_respond_to @object, :date
    assert_respond_to @object, :checksum
    assert_respond_to @object, :invoices
    assert_respond_to @object, :invoice_count
    assert_respond_to @object, :total
  end
end