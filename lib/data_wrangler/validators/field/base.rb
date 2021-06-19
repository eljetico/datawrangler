# frozen_string_literal: true

require_relative "../../field_processor"
require_relative "../result"

module DataWrangler
  module Validators
    module Field
      # Abstract validator class
      class Base < DataWrangler::FieldProcessor
        attr_reader :default_value

        def initialize(config = {})
          super(config)
          @autocorrect = @config.fetch("autocorrect", false)
          @default_value = @config.fetch("default_value", nil)
        end

        def autocorrectable?
          @autocorrect && !default_value.nil?
        end

        # def blank?(value = nil)
        #   value.to_s.eql?('')
        # end

        # def clean_token(token)
        #   token.to_s.gsub(/\A"|"\Z/, '').strip
        # end

        # def parse_list_values(string, delimiters = ';,|')
        #   return [] if string.nil?
        #
        #   string.scan(/\s*([^#{delimiters}]+)\s*/).flatten.reject { |r| blank?(r) }.map { |s| clean_token(s) }
        # end

        def process_value(value)
          _possibly_autocorrect(validate(value))
        end

        # Override this method in subclasses, but ensure
        # a Result instance is returned
        def validate(value = nil)
          DataWrangler::Validators::Result.success(value)
        end

        private

        # Autocorrect, if enabled
        def _possibly_autocorrect(result)
          return result if result.valid? || !autocorrectable?

          # TODO: check that default value is in valid options
          # during instantiation, as this would constitute a
          # configuration error
          validate(default_value)
        end
      end
    end
  end
end
