# frozen_string_literal: true

module DataWrangler
  module Configuration
    # Mixin methods for instantiating cell/record transformers
    module Processable
      # 'process' should be 'transform|conform|'
      def load_processor(namespace, context, process_type, config)
        process_method = extract_process_method(process_type)
        name = config[process_type]
        parent_namespace = "#{process_type.capitalize}s" # 'Transformers'
        klass_path = "DataWrangler::#{parent_namespace}::#{namespace}" # Field|Record etc
        klass_name = name.include?("::") ? name : "#{klass_path}::#{name}"

        klass = Object.const_get(klass_name).new(config.fetch("options", {}))

        unless klass.respond_to?(process_method.to_sym)
          raise DataWrangler::Configuration::Error, "#{name} (configured for #{context}) " \
            "should respond to '#{process_method}'"
        end

        klass
      rescue NameError => e
        raise DataWrangler::Configuration::Error, "#{name} cannot be instantiated: #{e.message}"
      end

      def load_field_processor(context, process_type, config)
        load_processor("Field", context, process_type, config)
      end

      def load_record_processor(context, process_type, config)
        load_processor("Record", context, process_type, config)
      end

      private

      def process_types
        {
          "transformer" => "transform",
          "conformer" => "conform",
          "validator" => "validate"
        }.freeze
      end

      def extract_process_method(process_type)
        process_types[process_type]
      end
    end
  end
end
