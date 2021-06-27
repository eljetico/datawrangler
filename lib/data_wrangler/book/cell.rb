# frozen_string_literal: true

module DataWrangler
  module Book
    # Wrap a value, could be anything, including another Cell
    class Cell
      attr_accessor :configuration, :ignore, :value

      def initialize(data_value)
        @value = data_value.respond_to?(:value) ? data_value.value : data_value
        @header = nil # updated during configure phase
        @ignore = false # ditto
        @configuration = nil # ditto
        @validation_result = nil
      end

      def empty?
        @value.to_s.eql?("")
      end

      def errors
        validated? ? @validation_result.errors : []
      end

      def header
        @configuration.header
      end

      def ignore?
        @ignore
      end

      def sanitized
        validated? ? @validation_result.sanitized : nil
      end

      # This should be the header as specified in config
      def sanitized_header
        @configuration.field_name
      end

      def valid?
        validated? ? @validation_result.valid? : false
      end

      def process
        return @validation_result.success? if validated?

        _process(@configuration.processors || [])
      end

      # Seed the processor chain with the original value, but we mutate
      # result into actual Result instances which can be passed into
      # further processors until first error met
      def _process(processors = [])
        @validation_result = nil
        result = DataWrangler::Validators::Result.success(@value)

        processors.each do |processor|
          result = processor.run(result)
          break if result.failure?
        end

        @validation_result = result
        @validation_result.success?
      end

      def validated?
        !@validation_result.nil?
      end
    end
  end
end
