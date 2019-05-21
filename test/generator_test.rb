require 'test_helper'
require 'nokogiri'
require_relative 'e_invoiceable_interface_test'

class EInvoiceDouble
  def date
    Date.parse('2010-07-05')
  end

  def checksum
    'checksum-1234'
  end

  def invoices
    seller = EInvoice::Seller.new
    seller.name = 'John Doe'
    seller.reg_no = 'john-1234'

    buyer_bank_account = EInvoice::BankAccount.new
    buyer_bank_account.number = 'GB33BUKB20201555555555'

    buyer = EInvoice::Buyer.new
    buyer.name = 'Jane Doe'
    buyer.bank_account = buyer_bank_account

    beneficiary = EInvoice::Beneficiary.new
    beneficiary.name = 'William Jones'
    beneficiary.iban = 'DE91100000000123456789'

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

    invoice = EInvoice::Invoice.new(seller: seller, buyer: buyer, beneficiary: beneficiary,
                                    items: [invoice_item]).tap do |invoice|
      invoice.number = 'invoice-1234'
      invoice.date = Date.parse('2010-07-06')
      invoice.recipient_id_code = 'recipient-1234'
      invoice.reference_number = '1234'
      invoice.due_date = Date.parse('2010-07-07')
      invoice.payer_name = 'John Smith'
      invoice.currency = 'EUR'
      invoice.subtotal = 100
      invoice.vat_amount = 20
      invoice.total = 120
    end

    [invoice]
  end

  def invoice_count
    1
  end

  def total
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
          <FileId>checksum-1234</FileId>
          <Version>1.2</Version>
        </Header>
        <Invoice invoiceId="invoice-1234" regNumber="recipient-1234" sellerRegnumber="john-1234">
          <InvoiceParties>
            <SellerParty>
              <Name>John Doe</Name>
              <RegNumber>john-1234</RegNumber>
            </SellerParty>
            <BuyerParty>
              <Name>Jane Doe</Name>
                <AccountInfo>
                  <AccountNumber>GB33BUKB20201555555555</AccountNumber>
                </AccountInfo>
            </BuyerParty>
          </InvoiceParties>
          <InvoiceInformation>
            <Type type="DEB"/>
            <DocumentName>ARVE</DocumentName>
            <InvoiceNumber>invoice-1234</InvoiceNumber>
            <InvoiceDate>2010-07-06</InvoiceDate>
            <DueDate>2010-07-07</DueDate>
          </InvoiceInformation>
          <InvoiceSumGroup>
            <InvoiceSum>100.0000</InvoiceSum>
            <TotalVATSum>20.00</TotalSum>
            <TotalSum>120.00</TotalSum>
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
            <Payable>YES</Payable>
            <PayDueDate>2010-07-07</PayDueDate>
            <PaymentTotalSum>120.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>DE91100000000123456789</PayToAccount>
            <PayToName>William Jones</PayToName>
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

  def test_generated_xml_conforms_to_estonian_e_invoice_standard_v1_2
    schema = Nokogiri::XML::Schema(File.read('test/xml_schemas/v1.2.xsd'))
    xml = @generator.generate(EInvoiceDouble.new)

    errors = schema.validate(Nokogiri::XML(xml))
    valid = errors.empty?
    assert valid, proc { errors.each { |error| puts error } }
  end
end
