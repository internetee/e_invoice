module EInvoice
  module Providers
    class << self
      def lookup(name, config)
        const_get(name.to_s.capitalize).new(config)
      end
    end
  end
end