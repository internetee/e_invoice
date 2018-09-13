# Ruby API for generating Estonian e-invoices

[![Build Status](https://travis-ci.org/internetee/estonian_e_invoice.svg?branch=master)](https://travis-ci.org/internetee/estonian_e_invoice)
[![Code Climate](https://codeclimate.com/github/internetee/estonian_e_invoice/badges/gpa.svg)](https://codeclimate.com/github/internetee/estonian_e_invoice)
[![Test Coverage](https://codeclimate.com/github/internetee/estonian_e_invoice/badges/coverage.svg)](https://codeclimate.com/github/internetee/estonian_e_invoice/coverage)

Implements Estonian e-invoice standard v1.2.

## Usage
```ruby
require 'estonian_e_invoice'

# Configure service provider
soap_client = Savon.client(wsdl: 'https://testfinance.post.ee/finance/erp/erpServices.wsdl') 
EstonianEInvoice.provider = EstonianEInvoice::Providers::Omniva.new(soap_client: soap_client,
                                                                    secret_key: 'secret-key-from-omniva-web-ui')

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
item.amount = Money.from_amount(10)
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
e_invoice.generate(Date.today) # Get e-invoice XML
e_invoice.deliver # Deliver to configured provider

```

### Resources
- [E-invoice description (in Estonian)](https://www.pangaliit.ee/arveldused/e-arve)