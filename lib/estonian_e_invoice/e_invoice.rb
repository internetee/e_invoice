module EstonianEInvoice
  class EInvoice
    def initialize(invoices)
      @invoices = invoices
    end

    def generate(current_date)
      builder = Builder::XmlMarkup.new(indent: 2)
      builder.instruct! :xml
      builder.E_Invoice('xsi:noNamespaceSchemaLocation' => 'e-invoice_ver1.2.xsd',
                        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance') do
        build_header(builder, current_date)
        build_invoices(builder)
        build_footer(builder)
      end
    end

    def deliver(provider: EstonianEInvoice.provider)
      provider.deliver(self)
    end

    private

    attr_reader :invoices

    def invoice_count
      invoices.size
    end

    def total
      invoices.sum(&:total)
    end

    def build_header(builder, current_date)
      builder.Header do
        builder.Date current_date
        builder.FileId 1
        builder.Version '1.2'
      end
    end

    def build_invoices(builder)
      invoices.each do |invoice|
        builder.Invoice(invoiceId: invoice.id,
                        regNumber: invoice.recipient_id_code,
                        sellerRegnumber: invoice.seller.reg_no) do
          builder.InvoiceParties do
            builder.SellerParty do
              builder.Name invoice.seller.name
              builder.RegNumber invoice.seller.reg_no
            end

            builder.BuyerParty do
              builder.Name invoice.buyer.name
            end
          end

          builder.InvoiceInformation do
            builder.Type(type: 'DEB')
            builder.DocumentName 'ARVE'
            builder.InvoiceNumber invoice.number
            builder.InvoiceDate invoice.date
          end

          builder.InvoiceSumGroup do
            builder.TotalSum format_money(invoice.total)
          end

          build_invoice_items(builder, invoice.items)

          builder.PaymentInfo do
            builder.Currency invoice.total.currency.iso_code
            builder.PaymentRefId invoice.reference_number
            builder.Payable 'YES'
            builder.PayDueDate invoice.due_date
            builder.PaymentTotalSum format_money(invoice.total)
            builder.PayerName invoice.payer_name
            builder.PaymentId invoice.number
            builder.PayToAccount invoice.beneficiary.iban
            builder.PayToName invoice.beneficiary.name
          end
        end
      end
    end

    def build_invoice_items(builder, items)
      items.each do |item|
        builder.InvoiceItem do
          builder.InvoiceItemGroup do
            builder.ItemEntry do
              builder.Description item.description
            end
          end
        end
      end
    end

    def build_footer(builder)
      builder.Footer do
        builder.TotalNumberInvoices invoice_count
        builder.TotalAmount format_money(total)
      end
    end

    def format_money(money)
      money.format(decimal_mark: '.', symbol: false, thousands_separator: false)
    end
  end
end