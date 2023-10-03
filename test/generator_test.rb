require 'test_helper'
require 'nokogiri'
require_relative 'e_invoiceable_interface_test'

class EInvoiceDouble
  def date
    Date.parse('2010-07-05')
  end

  def initialize(payable: true)
    @payable = payable == true ? true : false
  end

  def id
    'id1234'
  end

  def invoice(payable: @payable)
    seller = EInvoice::Seller.new
    seller.name = 'John Doe'
    seller.registration_number = 'john-1234'
    seller.vat_number = 'US1234'

    seller_legal_address = EInvoice::Address.new
    seller_legal_address.line1 = 'seller address line1'
    seller_legal_address.line2 = 'seller address line2'
    seller_legal_address.postal_code = '12345'
    seller_legal_address.city = 'seller address city'
    seller_legal_address.country = 'seller address country'
    seller.legal_address = seller_legal_address

    buyer = EInvoice::Buyer.new
    buyer.name = 'Jane Doe'
    buyer.registration_number = '1234'
    buyer.vat_number = 'US1234'
    buyer.email = 'info@buyer.test'

    buyer_bank_account = EInvoice::BankAccount.new
    buyer_bank_account.number = 'GB33BUKB20201555555555'
    buyer.bank_account = buyer_bank_account

    buyer_legal_address = EInvoice::Address.new
    buyer_legal_address.line1 = 'buyer address line1'
    buyer_legal_address.line2 = 'buyer address line2'
    buyer_legal_address.postal_code = '123456'
    buyer_legal_address.city = 'buyer address city'
    buyer_legal_address.country = 'buyer address country'
    buyer.legal_address = buyer_legal_address

    invoice_item = EInvoice::InvoiceItem.new.tap do |item|
      item.description = 'acme services'
      item.quantity = 1
      item.unit = 'pc'
      item.price = 100
      item.subtotal = 100
      item.vat_rate = 20
      item.vat_amount = 20
      item.total = 120
    end

    EInvoice::Invoice.new.tap do |invoice|
      invoice.seller = seller
      invoice.buyer = buyer
      invoice.items = [invoice_item]
      invoice.number = 'invoice-1234'
      invoice.date = Date.parse('2010-07-06')
      invoice.recipient_id_code = 'recipient-1234'
      invoice.reference_number = '1234'
      invoice.due_date = Date.parse('2010-07-07')
      invoice.payable = @payable
      invoice.beneficiary_name = 'Acme Ltd'
      invoice.beneficiary_account_number = 'GB33BUKB20201555555556'
      invoice.payer_name = 'John Smith'
      invoice.currency = 'EUR'
      invoice.subtotal = 100
      invoice.vat_amount = 20
      invoice.total = 120
      invoice.delivery_channel = :internet_bank
    end
  end

  def invoice_count
    1
  end

  def total_amount
    120
  end
end

class EInvoiceDoubleTest < Minitest::Test
  include EInvoiceableInterfaceTest

  def setup
    @object = EInvoiceDouble.new
  end
end

class GeneratorTest < Minitest::Test
  def setup
    @generator = EInvoice::Generator.new
  end

  def test_generates_e_invoice_xml
    expected_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <E_Invoice xsi:noNamespaceSchemaLocation="e-invoice_ver1.2.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <Header>
          <Date>2010-07-05</Date>
          <FileId>id1234</FileId>
          <Version>1.2</Version>
        </Header>
        <Invoice invoiceId="invoice-1234" regNumber="recipient-1234" sellerRegnumber="john-1234" serviceId="1234">
          <InvoiceParties>
            <SellerParty>
              <Name>John Doe</Name>
              <RegNumber>john-1234</RegNumber>
              <VATRegNumber>US1234</VATRegNumber>
                <ContactData>
                  <LegalAddress>
                    <PostalAddress1>seller address line1</PostalAddress1>
                    <PostalAddress2>seller address line2</PostalAddress2>
                    <City>seller address city</City>
                    <PostalCode>12345</PostalCode>
                    <Country>seller address country</Country>
                  </LegalAddress>
                </ContactData>
            </SellerParty>
            <BuyerParty>
              <Name>Jane Doe</Name>
              <RegNumber>1234</RegNumber>
              <VATRegNumber>US1234</VATRegNumber>
                <ContactData>
                  <E-mailAddress>info@buyer.test</E-mailAddress>
                  <LegalAddress>
                    <PostalAddress1>buyer address line1</PostalAddress1>
                    <PostalAddress2>buyer address line2</PostalAddress2>
                    <City>buyer address city</City>
                    <PostalCode>123456</PostalCode>
                    <Country>buyer address country</Country>
                  </LegalAddress>
                </ContactData>
                <AccountInfo>
                  <AccountNumber>GB33BUKB20201555555555</AccountNumber>
                </AccountInfo>
            </BuyerParty>
          </InvoiceParties>
          <InvoiceInformation>
            <Type type="DEB"/>
            <DocumentName>ARVE</DocumentName>
            <InvoiceNumber>invoice-1234</InvoiceNumber>
            <PaymentReferenceNumber>1234</PaymentReferenceNumber>
            <InvoiceDate>2010-07-06</InvoiceDate>
            <DueDate>2010-07-07</DueDate>
            <Extension extensionId="eakChannel">
              <InformationContent>INTERNET_BANK</InformationContent>
            </Extension>
            <Extension extensionId=\"eakStatusAfterImport\">
              <InformationContent>SENT</InformationContent>
            </Extension>
          </InvoiceInformation>
          <InvoiceSumGroup>
            <Balance/>
            <InvoiceSum>100.0000</InvoiceSum>
            <TotalVATSum>20.00</TotalSum>
            <TotalSum>120.00</TotalSum>
            <TotalToPay>120.00</TotalToPay>
            <Currency>EUR</Currency>
          </InvoiceSumGroup>
          <InvoiceItem>
            <InvoiceItemGroup>
              <ItemEntry>
                <Description>acme services</Description>
                <ItemDetailInfo>
                  <ItemUnit>pc</ItemUnit>
                  <ItemAmount>1.0000</ItemAmount>
                  <ItemPrice>100.0000</ItemPrice>
                </ItemDetailInfo>
                <ItemSum>100.0000</ItemSum>
                <VAT vatId="TAX">
                  <VATRate>20.00</VATRate>
                  <VATSum>20.0000</VATSum>
                </VAT>
                <ItemTotal>120.0000</ItemTotal>
              </ItemEntry>
            </InvoiceItemGroup>
            <InvoiceItemTotalGroup>
              <InvoiceItemTotalAmount>120.0000</InvoiceItemTotalAmount>
              <InvoiceItemTotalSum>100.0000</InvoiceItemTotalSum>
              <InvoiceItemTotal>120.0000</InvoiceItemTotal>
            </InvoiceItemTotalGroup>
          </InvoiceItem>
          <PaymentInfo>
            <Currency>EUR</Currency>
            <PaymentRefId>1234</PaymentRefId>
            <PaymentDescription>invoice-1234</PaymentDescription>
            <Payable>YES</Payable>
            <PayDueDate>2010-07-07</PayDueDate>
            <PaymentTotalSum>120.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>GB33BUKB20201555555556</PayToAccount>
            <PayToName>Acme Ltd</PayToName>
          </PaymentInfo>
        </Invoice>
        <Footer>
          <TotalNumberInvoices>1</TotalNumberInvoices>
          <TotalAmount>120.00</TotalAmount>
        </Footer>
      </E_Invoice>
    XML
    actual_xml = Nokogiri::XML(@generator.generate(EInvoiceDouble.new)) { |config| config.noblanks }
                   .to_xml

    expected_xml = Nokogiri::XML(expected_xml) { |config| config.noblanks }.to_xml
    assert_equal expected_xml, actual_xml
  end

  def test_generates_prepaid_e_invoice_xml
    expected_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <E_Invoice xsi:noNamespaceSchemaLocation="e-invoice_ver1.2.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <Header>
          <Date>2010-07-05</Date>
          <FileId>id1234</FileId>
          <Version>1.2</Version>
        </Header>
        <Invoice invoiceId="invoice-1234" regNumber="recipient-1234" sellerRegnumber="john-1234" serviceId="1234">
          <InvoiceParties>
            <SellerParty>
              <Name>John Doe</Name>
              <RegNumber>john-1234</RegNumber>
              <VATRegNumber>US1234</VATRegNumber>
                <ContactData>
                  <LegalAddress>
                    <PostalAddress1>seller address line1</PostalAddress1>
                    <PostalAddress2>seller address line2</PostalAddress2>
                    <City>seller address city</City>
                    <PostalCode>12345</PostalCode>
                    <Country>seller address country</Country>
                  </LegalAddress>
                </ContactData>
            </SellerParty>
            <BuyerParty>
              <Name>Jane Doe</Name>
              <RegNumber>1234</RegNumber>
              <VATRegNumber>US1234</VATRegNumber>
                <ContactData>
                  <E-mailAddress>info@buyer.test</E-mailAddress>
                  <LegalAddress>
                    <PostalAddress1>buyer address line1</PostalAddress1>
                    <PostalAddress2>buyer address line2</PostalAddress2>
                    <City>buyer address city</City>
                    <PostalCode>123456</PostalCode>
                    <Country>buyer address country</Country>
                  </LegalAddress>
                </ContactData>
                <AccountInfo>
                  <AccountNumber>GB33BUKB20201555555555</AccountNumber>
                </AccountInfo>
            </BuyerParty>
          </InvoiceParties>
          <InvoiceInformation>
            <Type type="DEB"/>
            <DocumentName>ARVE</DocumentName>
            <InvoiceNumber>invoice-1234</InvoiceNumber>
            <PaymentReferenceNumber>1234</PaymentReferenceNumber>
            <InvoiceDate>2010-07-06</InvoiceDate>
            <DueDate>2010-07-07</DueDate>
            <Extension extensionId="eakChannel">
              <InformationContent>INTERNET_BANK</InformationContent>
            </Extension>
            <Extension extensionId=\"eakStatusAfterImport\">
              <InformationContent>SENT</InformationContent>
            </Extension>
          </InvoiceInformation>
          <InvoiceSumGroup>
            <Balance/>
            <InvoiceSum>100.0000</InvoiceSum>
            <TotalVATSum>20.00</TotalSum>
            <TotalSum>120.00</TotalSum>
            <TotalToPay>0.00</TotalToPay>
            <Currency>EUR</Currency>
          </InvoiceSumGroup>
          <InvoiceItem>
            <InvoiceItemGroup>
              <ItemEntry>
                <Description>acme services</Description>
                <ItemDetailInfo>
                  <ItemUnit>pc</ItemUnit>
                  <ItemAmount>1.0000</ItemAmount>
                  <ItemPrice>100.0000</ItemPrice>
                </ItemDetailInfo>
                <ItemSum>100.0000</ItemSum>
                <VAT vatId="TAX">
                  <VATRate>20.00</VATRate>
                  <VATSum>20.0000</VATSum>
                </VAT>
                <ItemTotal>120.0000</ItemTotal>
              </ItemEntry>
            </InvoiceItemGroup>
            <InvoiceItemTotalGroup>
              <InvoiceItemTotalAmount>120.0000</InvoiceItemTotalAmount>
              <InvoiceItemTotalSum>100.0000</InvoiceItemTotalSum>
              <InvoiceItemTotal>120.0000</InvoiceItemTotal>
            </InvoiceItemTotalGroup>
          </InvoiceItem>
          <PaymentInfo>
            <Currency>EUR</Currency>
            <PaymentRefId>1234</PaymentRefId>
            <PaymentDescription>invoice-1234</PaymentDescription>
            <Payable>NO</Payable>
            <PayDueDate>2010-07-07</PayDueDate>
            <PaymentTotalSum>0.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>GB33BUKB20201555555556</PayToAccount>
            <PayToName>Acme Ltd</PayToName>
          </PaymentInfo>
        </Invoice>
        <Footer>
          <TotalNumberInvoices>1</TotalNumberInvoices>
          <TotalAmount>120.00</TotalAmount>
        </Footer>
      </E_Invoice>
    XML
    actual_xml = Nokogiri::XML(@generator.generate(EInvoiceDouble.new(payable: false))) { |config| config.noblanks }
                   .to_xml

    expected_xml = Nokogiri::XML(expected_xml) { |config| config.noblanks }.to_xml
    assert_equal expected_xml, actual_xml
  end

  def test_generated_xml_conforms_to_estonian_e_invoice_standard_v1_2
    schema = Nokogiri::XML::Schema(File.read('test/xml_schemas/v1.2.xsd'))
    xml = @generator.generate(EInvoiceDouble.new)

    errors = schema.validate(Nokogiri::XML(xml))
    valid = errors.empty?
    assert valid, proc { errors.each { |error| puts error } }
  end
end