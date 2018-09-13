require 'test_helper'
require 'nokogiri'

class EInvoiceTest < Minitest::Test
  def test_generate_xml
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
            <TotalSum>5000.00</TotalSum>
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
            <PaymentTotalSum>5000.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-1234</PaymentId>
            <PayToAccount>DE91100000000123456789</PayToAccount>
            <PayToName>William Jones</PayToName>
          </PaymentInfo>
        </Invoice>
        <Invoice invoiceId="invoice-12345" regNumber="recipient-1234" sellerRegnumber="john-1234">
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
            <InvoiceNumber>invoice-12345</InvoiceNumber>
            <InvoiceDate>2010-07-06</InvoiceDate>
          </InvoiceInformation>
          <InvoiceSumGroup>
            <TotalSum>5000.00</TotalSum>
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
            <PaymentRefId>12345</PaymentRefId>
            <Payable>YES</Payable>
            <PayDueDate>2010-07-07</PayDueDate>
            <PaymentTotalSum>5000.00</PaymentTotalSum>
            <PayerName>John Smith</PayerName>
            <PaymentId>invoice-12345</PaymentId>
            <PayToAccount>DE91100000000123456789</PayToAccount>
            <PayToName>William Jones</PayToName>
          </PaymentInfo>
        </Invoice>
        <Footer>
          <TotalNumberInvoices>2</TotalNumberInvoices>
          <TotalAmount>10000.00</TotalAmount>
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
    item.amount = Money.from_amount(5000)
    items = [item]

    invoice1 = EstonianEInvoice::Invoice.new(seller, buyer, beneficiary, items)
    invoice1.id = 'invoice-1234'
    invoice1.number = 'invoice-1234'
    invoice1.date = Date.parse('2010-07-06')
    invoice1.recipient_id_code = 'recipient-1234'
    invoice1.reference_number = '1234'
    invoice1.due_date = Date.parse('2010-07-07')
    invoice1.payer_name = 'John Smith'

    invoice2 = EstonianEInvoice::Invoice.new(seller, buyer, beneficiary, items)
    invoice2.id = 'invoice-12345'
    invoice2.number = 'invoice-12345'
    invoice2.date = Date.parse('2010-07-06')
    invoice2.recipient_id_code = 'recipient-1234'
    invoice2.reference_number = '12345'
    invoice2.due_date = Date.parse('2010-07-07')
    invoice2.payer_name = 'John Smith'

    invoices = [invoice1, invoice2]

    e_invoice = EstonianEInvoice::EInvoice.new(invoices)
    current_date = Date.parse('2010-07-05')
    assert_equal Nokogiri::XML(expected_xml).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML), Nokogiri::XML(e_invoice.generate(current_date)).to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
  end

  def test_deliver_to_provider
    e_invoice = EstonianEInvoice::EInvoice.new([])

    provider = Minitest::Mock.new
    provider.expect(:deliver, true, [e_invoice])
    EstonianEInvoice.provider = provider

    e_invoice.deliver
    provider.verify
  end
end