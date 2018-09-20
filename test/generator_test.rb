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
    seller = EstonianEInvoice::Seller.new
    seller.name = 'John Doe'
    seller.reg_no = 'john-1234'

    buyer = EstonianEInvoice::Buyer.new
    buyer.name = 'Jane Doe'

    beneficiary = EstonianEInvoice::Beneficiary.new
    beneficiary.name = 'William Jones'
    beneficiary.iban = 'DE91100000000123456789'

    item = EstonianEInvoice::InvoiceItem.new
    item.description = 'acme services'
    item.amount = Money.from_amount(1000)

    invoice = EstonianEInvoice::Invoice.new(seller: seller, buyer: buyer, beneficiary: beneficiary,
                                            items: [item])
    invoice.id = 'invoice-1234'
    invoice.number = 'invoice-1234'
    invoice.date = Date.parse('2010-07-06')
    invoice.recipient_id_code = 'recipient-1234'
    invoice.reference_number = '1234'
    invoice.due_date = Date.parse('2010-07-07')
    invoice.payer_name = 'John Smith'

    [invoice]
  end

  def invoice_count
    1
  end

  def total
    Money.from_amount(3000)
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
    @generator = EstonianEInvoice::Generator.new
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
            </BuyerParty>
          </InvoiceParties>
          <InvoiceInformation>
            <Type type="DEB"/>
            <DocumentName>ARVE</DocumentName>
            <InvoiceNumber>invoice-1234</InvoiceNumber>
            <InvoiceDate>2010-07-06</InvoiceDate>
          </InvoiceInformation>
          <InvoiceSumGroup>
            <TotalSum>1000.00</TotalSum>
          </InvoiceSumGroup>
          <InvoiceItem>
            <InvoiceItemGroup>
              <ItemEntry>
                <Description>acme services</Description>
              </ItemEntry>
            </InvoiceItemGroup>
          </InvoiceItem>
          <PaymentInfo>
            <Currency>EUR</Currency>
            <PaymentRefId>1234</PaymentRefId>
            <Payable>YES</Payable>
            <PayDueDate>2010-07-07</PayDueDate>
            <PaymentTotalSum>1000.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>DE91100000000123456789</PayToAccount>
            <PayToName>William Jones</PayToName>
          </PaymentInfo>
        </Invoice>
        <Footer>
          <TotalNumberInvoices>1</TotalNumberInvoices>
          <TotalAmount>3000.00</TotalAmount>
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