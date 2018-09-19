module ProviderInterfaceTest
  def test_implements_the_provider_interface
    assert_respond_to @object, :deliver
  end
end