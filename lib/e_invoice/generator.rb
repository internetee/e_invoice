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
        build_invoice(e_invoice.invoice)
        build_footer(e_invoice)
      end
    end

    private

    attr_reader :builder

    def build_header(e_invoice)
      builder.Header do
        builder.Date e_invoice.date
        builder.FileId e_invoice.id
        builder.Version '1.2'
      end
    end

    def build_invoice(invoice)
      builder.Invoice(invoiceId: invoice.id,
                      regNumber: invoice.recipient_id_code,
                      sellerRegnumber: invoice.seller.registration_number,
                      serviceId: invoice.reference_number) do
        build_invoice_party_details(invoice)
        build_invoice_details(invoice)
        build_invoice_totals(invoice)
        if invoice.monthly_invoice
          build_monthly_invoice_items(invoice.items)
        else
          build_invoice_items(invoice.items)
        end
        build_invoice_payment_details(invoice)
      end
    end

    def build_invoice_party_details(invoice)
      builder.InvoiceParties do
        builder.SellerParty do
          builder.Name invoice.seller.name
          builder.RegNumber invoice.seller.registration_number
          builder.VATRegNumber invoice.seller.vat_number
          builder.ContactData do
            builder.LegalAddress do
              builder.PostalAddress1 invoice.seller.legal_address.line1
              builder.PostalAddress2 invoice.seller.legal_address.line2
              builder.City invoice.seller.legal_address.city
              builder.PostalCode invoice.seller.legal_address.postal_code
              builder.Country invoice.seller.legal_address.country
            end
          end
        end

        builder.BuyerParty do
          builder.Name invoice.buyer.name
          builder.RegNumber invoice.buyer.registration_number
          builder.VATRegNumber invoice.buyer.vat_number
          builder.ContactData do
            # According to the Estonian Banking Association, it should be `EmailAddress` (no dash),
            # however, XML schema requires dashed version.
            # https://www.pangaliit.ee/arveldused/e-arve
            builder.tag!('E-mailAddress', invoice.buyer.email)

            builder.LegalAddress do
              builder.PostalAddress1 invoice.buyer.legal_address.line1
              builder.PostalAddress2 invoice.buyer.legal_address.line2
              builder.City invoice.buyer.legal_address.city
              builder.PostalCode invoice.buyer.legal_address.postal_code
              builder.Country invoice.buyer.legal_address.country
            end
          end

          builder.AccountInfo do
            builder.AccountNumber invoice.buyer.bank_account.number
          end
        end
      end
    end

    def build_invoice_details(invoice)
      builder.InvoiceInformation do
        builder.Type(type: 'DEB')
        builder.DocumentName invoice.name || 'ARVE'
        builder.InvoiceNumber invoice.number
        builder.PaymentReferenceNumber invoice.reference_number
        builder.InvoiceDate invoice.date
        builder.DueDate invoice.due_date

        invoice.delivery_channel.each do |delivery_channel|
          builder.Extension(extensionId: 'eakChannel') do
            builder.InformationContent delivery_channel.to_s.upcase
          end
        end
        builder.Extension(extensionId: 'eakStatusAfterImport') do
          builder.InformationContent 'SENT'
        end
      end
    end

    def build_invoice_totals(invoice)
      builder.InvoiceSumGroup do
        build_invoice_balance(invoice)
        builder.InvoiceSum format_decimal(invoice.subtotal, scale: 4)
        builder.TotalVATSum format_decimal(invoice.vat_amount)
        builder.TotalSum format_decimal(invoice.total)
        if invoice.payable == false
          builder.TotalToPay format_decimal(0)
        else
          builder.TotalToPay format_decimal(invoice.total_to_pay || invoice.total)
        end
        builder.Currency invoice.currency
      end
    end

    def build_invoice_balance(invoice)
      builder.Balance do
        build_element('BalanceDate', invoice.balance_date)
        build_element('BalanceBegin', invoice.balance_begin, :format_decimal)
        build_element('Inbound', invoice.inbound, :format_decimal)
        build_element('Outbound', invoice.outbound, :format_decimal)
        build_element('BalanceEnd', invoice.balance_end, :format_decimal)
      end
    end

    def build_element(name, value, format_method = nil)
      return unless value

      formatted_value = format_method ? send(format_method, value) : value
      builder.__send__(name, formatted_value)
    end

    def build_invoice_payment_details(invoice)
      builder.PaymentInfo do
        builder.Currency invoice.currency
        builder.PaymentRefId invoice.reference_number
        builder.PaymentDescription invoice.number
        builder.Payable invoice.payable == false ? 'NO' : 'YES'
        builder.PayDueDate invoice.due_date
        if invoice.payable == false
          builder.PaymentTotalSum format_decimal(0)
        else
          builder.PaymentTotalSum format_decimal(invoice.total_to_pay || invoice.total)
        end
        builder.PayerName invoice.payer_name
        builder.PaymentId invoice.number
        builder.PayToAccount invoice.beneficiary_account_number
        builder.PayToName invoice.beneficiary_name
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

    def build_monthly_invoice_items(items)
      builder.InvoiceItem do
        builder.InvoiceItemGroup do
          items.each do |item|
            builder.ItemEntry do
              builder.SellerProductId item.product_id if item.product_id
              builder.Description item.description

              builder.ItemDetailInfo do
                if item.quantity && item.price
                  builder.ItemUnit item.unit
                  builder.ItemAmount format_decimal(item.quantity, scale: 4)
                  builder.ItemPrice format_decimal(item.price, scale: 4)
                end
              end

              builder.ItemSum format_decimal(item.subtotal || 0, scale: 4)

              builder.VAT(vatId: 'TAX') do
                builder.VATRate format_decimal(item.vat_rate)
                builder.VATSum format_decimal(item.vat_amount || 0, scale: 4)
              end

              builder.ItemTotal format_decimal(item.total || 0, scale: 4)
            end
          end
        end
      end
    end

    def build_footer(e_invoice)
      builder.Footer do
        builder.TotalNumberInvoices e_invoice.invoice_count
        builder.TotalAmount format_decimal(e_invoice.total_amount)
      end
    end

    def format_decimal(decimal, scale: 2)
      format("%.#{scale}f", decimal) if decimal
    end
  end
end
