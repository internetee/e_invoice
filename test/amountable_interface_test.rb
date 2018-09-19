module AmountableInterfaceTest
  def test_implements_the_amountable_interface
    assert_respond_to @object, :amount
  end
end