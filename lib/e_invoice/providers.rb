module EInvoice
  module Providers
    class << self
      def lookup(name, user_config)
        config = OpenStruct.new(global_config(name).merge(user_config))
        const_get(name.to_s.capitalize).new(config)
      end

      private

      def global_config(name)
        YAML.load_file(Pathname(__dir__).join("providers/#{name}/config.yml"))
      end
    end
  end
end