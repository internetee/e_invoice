module EInvoice
  class Generator
    def initialize
      @builder = Builder::XmlMarkup.new
    end

    def generate(e_invoice)
      builder.instruct! :xml
      builder.E_Invoice('xsi:noNamespaceSchemaLocation' => 'e-invoice_ver1.2.xsd',
                        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance') do
        build_header(e_invoice)
        build_invoices(e_invoice.invoices)
        build_footer(e_invoice)
      end
    end

    private

    attr_reader :builder

    def build_header(e_invoice)
      builder.Header do
        builder.Date e_invoice.date
        builder.FileId e_invoice.checksum
        builder.Version '1.2'
      end
    end

    def build_invoices(invoices)
      invoices.each do |invoice|
        build_invoice(invoice)
      end
    end

    def build_invoice(invoice)
      builder.Invoice(invoiceId: invoice.id,
                      regNumber: invoice.recipient_id_code,
                      sellerRegnumber: invoice.seller.reg_no,
                      channelAddress: invoice.delivery_channel_address) do
        build_invoice_party_details(invoice)
        build_invoice_details(invoice)
        build_invoice_totals(invoice)
        build_invoice_items(invoice.items)
        build_invoice_payment_details(invoice)
      end
    end

    def build_invoice_party_details(invoice)
      builder.InvoiceParties do
        builder.SellerParty do
          builder.Name invoice.seller.name
          builder.RegNumber invoice.seller.reg_no
        end

        builder.BuyerParty do
          builder.Name invoice.buyer.name
        end
      end
    end

    def build_invoice_details(invoice)
      builder.InvoiceInformation do
        builder.Type(type: 'DEB')
        builder.DocumentName 'ARVE'
        builder.InvoiceNumber invoice.number
        builder.InvoiceDate invoice.date
        builder.DueDate invoice.due_date
      end
    end

    def build_invoice_totals(invoice)
      builder.InvoiceSumGroup do
        builder.InvoiceSum format_decimal(invoice.subtotal, scale: 4)
        builder.TotalVATSum format_decimal(invoice.vat_amount)
        builder.TotalSum format_decimal(invoice.total)
        builder.Currency invoice.currency
      end
    end

    def build_invoice_payment_details(invoice)
      builder.PaymentInfo do
        builder.Currency invoice.currency
        builder.PaymentRefId invoice.reference_number
        builder.Payable 'YES'
        builder.PayDueDate invoice.due_date
        builder.PaymentTotalSum format_decimal(invoice.total)
        builder.PayerName invoice.payer_name
        builder.PaymentId invoice.number
        builder.PayToAccount invoice.beneficiary.iban
        builder.PayToName invoice.beneficiary.name
      end
    end

    def build_invoice_items(items)
      items.each do |item|
        builder.InvoiceItem do
          builder.InvoiceItemGroup do
            builder.ItemEntry do
              builder.Description item.description

              builder.ItemDetailInfo do
                builder.ItemUnit item.unit
                builder.ItemAmount format_decimal(item.quantity, scale: 4)
                builder.ItemPrice format_decimal(item.price, scale: 4)
              end

              builder.ItemSum format_decimal(item.subtotal, scale: 4)

              builder.VAT(vatId: 'TAX') do
                builder.VATRate format_decimal(item.vat_rate)
                builder.VATSum format_decimal(item.vat_amount, scale: 4)
              end

              builder.ItemTotal format_decimal(item.total, scale: 4)
            end
          end

          builder.InvoiceItemTotalGroup do
            builder.InvoiceItemTotalAmount format_decimal(item.total, scale: 4)
            builder.InvoiceItemTotalSum format_decimal(item.subtotal, scale: 4)

            builder.InvoiceItemTotal format_decimal(item.total, scale: 4)
          end
        end
      end
    end

    def build_footer(e_invoice)
      builder.Footer do
        builder.TotalNumberInvoices e_invoice.invoice_count
        builder.TotalAmount format_decimal(e_invoice.total)
      end
    end

    def format_decimal(decimal, scale: 2)
      format("%.#{scale}f", decimal)
    end
  end
end
