require 'test_helper'
require 'nokogiri'

class EInvoiceTest < Minitest::Test
  def test_generate
    expected_xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <E_Invoice xsi:noNamespaceSchemaLocation="e-invoice_ver1.2.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <Header>
          <Date>2010-07-05</Date>
          <FileId>1</FileId>
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
            <TotalSum>5.00</TotalSum>
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
            <PaymentRefId>1234</PaymentDescription>
            <Payable>YES</Payable>
            <PayDueDate>2010-07-06</Payable>
            <PaymentTotalSum>5.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>DE91100000000123456789</PayToAccount>
            <PayToName>William Jones</PayToName>
          </PaymentInfo>
        </Invoice>
        <Footer>
          <TotalNumberInvoices>1</TotalNumberInvoices>
          <TotalAmount>5.00</TotalAmount>
        </Footer>
      </E_Invoice>
    XML

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
    item.amount = Money.from_amount(5)
    items = [item]

    invoice = EstonianEInvoice::Invoice.new(seller, buyer, beneficiary, items)
    invoice.id = 'invoice-1234'
    invoice.number = 'invoice-1234'
    invoice.date = Date.parse('2010-07-06')
    invoice.recipient_id_code = 'recipient-1234'
    invoice.reference_number = '1234'
    invoice.due_date = Date.parse('2010-07-07')
    invoice.payer_name = 'John Smith'
    invoices = [invoice]

    e_invoice = EstonianEInvoice::EInvoice.new(invoices)
    current_date = Date.parse('2010-07-05')
    assert_equal Nokogiri::XML(expected_xml).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML), Nokogiri::XML(e_invoice.generate(current_date)).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
  end
end