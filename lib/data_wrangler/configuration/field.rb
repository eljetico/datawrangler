# frozen_string_literal: true

require_relative "processable"
# require_relative 'transformable'
# require_relative 'validatable'

module DataWrangler
  module Configuration
    # Wrapper for specific field requirements
    class Field
      include Processable

      attr_reader :field_name, :header, :processors, :validators

      def initialize(field_name, config = nil)
        @field_name = field_name
        @config = _default_config.deep_merge(config || {})
        @header = _instantiate_header
        @processors = _instantiate_processors
        @validators = _instantiate_validators
      end

      def aliases
        @header.aliases
      end

      def append_to
        @append_to ||= @config.fetch("append_to", nil)
      end

      def autofill?
        @autofill ||= @config.fetch("autofill", false)
      end

      def default_value
        @default_value ||= @config.fetch("default_value", nil)
      end

      def key_field?
        @key_field ||= @config.fetch("key_field", false)
      end

      def multiple_values?
        @multiple_values ||= @config.fetch("multiple_values", false)
      end

      def required?
        @required ||= @config.fetch("required_header", true)
      end

      def sanitized_field_name
        @sanitized_field_name ||= _sanitize_field_name
      end

      def valid_headers
        @valid_headers ||= [
          field_name,
          sanitized_field_name,
          aliases
        ].flatten.compact.uniq
      end

      private

      def _default_config
        {
          "multiple_values" => false,
          "autofill" => false,
          "required_header" => true,
          "aliases" => [],
          "processors" => []
        }
      end

      def _instantiate_header
        klass_name = @config.fetch("header", "DataWrangler::Header")
        Object.const_get(klass_name).new(@field_name, @config.slice("aliases"))
      rescue NameError => e
        raise DataWrangler::Configuration::Error, "#{klass_name} cannot be instantiated: #{e.message}"
      end

      def _instantiate_processors
        @config.fetch("processors", []).map do |pconfig|
          ptype = pconfig.keys.find { |k| %w[transformer conformer].include?(k) }
          _config_error("Cannot configure processor #{pconfig}") if ptype.nil?

          load_field_processor(field_name, ptype, pconfig)
        end
      end

      def _instantiate_validators
        @config.fetch("validators", []).map do |pconfig|
          load_field_processor(field_name, "validator", pconfig)
        end
      end

      def _sanitize_field_name
        field_name.downcase
      end

      def _config_error(msg)
        raise DataWrangler::Configuration::Error, msg
      end
    end
  end
end
