module EstonianEInvoice
  class EInvoice
    def initialize(invoices)
      @invoices = invoices
    end

    def generate(current_date)
      xml = Builder::XmlMarkup.new(indent: 2)
      xml.instruct! :xml
      xml.E_Invoice('xsi:noNamespaceSchemaLocation' => 'e-invoice_ver1.2.xsd',
                    'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance') do
        xml.Header do
          xml.Date current_date
          xml.FileId 1
          xml.Version '1.2'
        end

        invoices.each do |invoice|
          xml.Invoice(invoiceId: invoice.id,
                      regNumber: invoice.recipient_id_code,
                      sellerRegnumber: invoice.seller.reg_no) do
            xml.InvoiceParties do
              xml.SellerParty do
                xml.Name invoice.seller.name
                xml.RegNumber invoice.seller.reg_no
              end

              xml.BuyerParty do
                xml.Name invoice.buyer.name
              end
            end

            xml.InvoiceInformation do
              xml.Type(type: 'DEB')
              xml.DocumentName 'ARVE'
              xml.InvoiceNumber invoice.number
              xml.InvoiceDate invoice.date
            end

            xml.InvoiceSumGroup do
              xml.TotalSum invoice.total
            end

            invoice.items.each do |item|
              xml.InvoiceItem do
                xml.InvoiceItemGroup do
                  xml.ItemEntry do
                    xml.Description item.description
                  end
                end
              end
            end

            xml.PaymentInfo do
              xml.Currency invoice.total.currency.iso_code
              xml.PaymentRefId invoice.reference_number
              xml.Payable 'YES'
              xml.PayDueDate invoice.due_date
              xml.PaymentTotalSum total
              xml.PayerName invoice.payer_name
              xml.PaymentId invoice.number
              xml.PayToAccount invoice.beneficiary.iban
              xml.PayToName invoice.beneficiary.name
            end
          end
        end

        xml.Footer do
          xml.TotalNumberInvoices invoice_count
          xml.TotalAmount total
        end
      end
    end

    private

    attr_reader :invoices

    def invoice_count
      invoices.size
    end

    def total
      invoices.sum(&:total)
    end
  end
end