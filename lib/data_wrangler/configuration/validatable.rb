# frozen_string_literal: true

module DataWrangler
  module Configuration
    # Mixin methods for instantiating validators within configuration step
    module Validatable
      def load_validator(context, namespace, config)
        name = config["validator"]
        context = "DataWrangler::Validations::#{context}"
        name = name.include?("::") ? name : "#{context}::#{name}"
        klass = Object.const_get(name).new(config.fetch("options", {}))

        unless klass.respond_to?(:validate)
          raise DataWrangler::Configuration::Error, "#{name} (configured for #{namespace}) " \
            "should respond to 'validate'"
        end

        klass
      rescue NameError => _e
        raise DataWrangler::Configuration::Error, "#{name} cannot be instantiated"
      end

      def load_field_validator(namespace, config)
        load_validator("Field", namespace, config)
      end

      def load_record_validator(namespace, config)
        load_validator("Record", namespace, config)
      end

      def load_sheet_validator(namespace, config)
        load_validator("Sheet", namespace, config)
      end
    end
  end
end
