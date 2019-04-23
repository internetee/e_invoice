module EInvoice
  class Config
    attr_reader :env
    attr_reader :data

    def initialize(env:, filename:)
      @env = env
      @data = YAML.load_file(filename)
      define_methods_for_environment(data[env].keys)
    end

    private

    def define_methods_for_environment(names)
      names.each do |name|
        instance_eval <<-RUBY
          def #{name}
            data[env]['#{name}']
          end
        RUBY
      end
    end
  end
end