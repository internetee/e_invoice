module EInvoice
  class Invoice
    attr_accessor :seller, :buyer, :items, :number, :name,
                  :date, :recipient_id_code, :reference_number,
                  :due_date, :payable, :payer_name,
                  :beneficiary_name, :beneficiary_account_number,
                  :subtotal, :vat_amount, :total, :total_to_pay, :currency,
                  :balance_date, :balance_begin, :inbound, :outbound,
                  :balance_end, :monthly_invoice

    alias_method :id, :number

    attr_reader :delivery_channel

    def self.valid_delivery_channels
      %i[internet_bank portal]
    end

    def delivery_channel=(channels)
      channels = Array(channels)
      validate_delivery_channels(channels)
      @delivery_channel = channels
    end

    private

    def validate_delivery_channels(channels)
      channels.each do |channel|
        valid = self.class.valid_delivery_channels.include?(channel)

        error_message = <<~TEXT.gsub("\n", "\s").strip
          Delivery channel "#{channel}" is invalid.
          Valid channels are: [:internet_bank, :portal]
        TEXT
        raise ArgumentError, error_message unless valid
      end
    end
  end
end
