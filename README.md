# Ruby API for generating and delivering Estonian e-invoices

[![Build Status](https://travis-ci.org/internetee/e_invoice.svg?branch=master)](https://travis-ci.org/internetee/e_invoice)
[![Code Climate](https://codeclimate.com/github/internetee/e_invoice/badges/gpa.svg)](https://codeclimate.com/github/internetee/e_invoice)
[![Test Coverage](https://codeclimate.com/github/internetee/e_invoice/badges/coverage.svg)](https://codeclimate.com/github/internetee/e_invoice/coverage)

Implements Estonian e-invoice standard v1.2.

## Supported providers
- Omniva

## Installation with Bundler
Add gem to your `Gemfile`:

`gem 'e_invoice', git: 'https://github.com/internetee/e_invoice', branch: 'master'`

## Usage
```ruby
require 'e_invoice'

# Configure provider
soap_client = Savon.client(wsdl: 'https://testfinance.post.ee/finance/erp/erpServices.wsdl')
secret_key = 'secret-key-from-omniva-web-ui' 
EInvoice.provider = EInvoice::Providers::Omniva.new(soap_client: soap_client,
                                                                    secret_key: secret_key)
                                                                    
seller = EInvoice::Seller.new
seller.name = 'John Doe'
seller.reg_no = 'john-1234'

buyer = EInvoice::Buyer.new
buyer.name = 'Jane Doe'

beneficiary = EInvoice::Beneficiary.new
beneficiary.name = 'William Jones'
beneficiary.iban = 'DE91100000000123456789'

item = EInvoice::InvoiceItem.new
item.description = 'acme services'
item.amount = 10

invoice = EInvoice::Invoice.new(seller: seller, buyer: buyer, beneficiary: beneficiary, 
                                        items: [item])
invoice.id = 'invoice-1234'
invoice.number = 'invoice-1234'
invoice.date = Date.parse('2010-07-06')
invoice.recipient_id_code = 'recipient-1234'
invoice.reference_number = '1234'
invoice.due_date = Date.parse('2010-07-07')
invoice.payer_name = 'John Smith'
invoice.currency = 'EUR'

invoices = [invoice]
e_invoice = EInvoice::EInvoice.new(invoices)
e_invoice.deliver # Delivers to configured provider
```

## Adding new provider
1. Create a new class in `lib/e_invoice/providers`, for example `custom.rb`.
2. Ensure it has a method with the signature of `deliver(e_invoice)`, which will be called
by `EInvoice` class when you ask it to be delivered, passing itself along.
3. Point the gem to use your brand new provider by passing an invoice of it 
to `EInvoice.provider` (see `Usage` section).

## Resources
- [E-invoice description (in Estonian)](https://www.pangaliit.ee/arveldused/e-arve)