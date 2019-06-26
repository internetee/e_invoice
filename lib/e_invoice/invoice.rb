module EInvoice
  class Invoice
    attr_accessor :seller
    attr_accessor :buyer
    attr_accessor :items

    attr_accessor :number
    alias_method :id, :number

    attr_accessor :date
    attr_accessor :recipient_id_code
    attr_accessor :reference_number
    attr_accessor :due_date
    attr_accessor :payer_name
    attr_accessor :beneficiary_name
    attr_accessor :beneficiary_account_number
    attr_accessor :subtotal
    attr_accessor :vat_amount
    attr_accessor :total
    attr_accessor :currency
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