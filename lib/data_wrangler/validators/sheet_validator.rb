# frozen_string_literal: true

require_relative "field_validator"
require_relative "record_validator"
require_relative "sheet/base"
require_relative "sheet/required_headers"
require_relative "sheet/unique_records"
require_relative "sheet/valid_records"

module DataWrangler
  module Validators
    # Sheet validations
    # 1. Ensure we have required headers for this sheet
    # 2. Validate records
    class SheetValidator
      attr_reader :errors

      # Accepts pre-configured DataWrangler::Book::Sheet
      def initialize(sheet, configuration = nil)
        @sheet = sheet
        @configuration = configuration || @sheet.configuration
        @validations = @configuration.sheet_validations
        @errors = {}
        partition_validations
      end

      # Split configured validations between post-load (deferred) and pre-load
      def partition_validations
        @post_load_validations = @validations.select(&:deferred?)
        @pre_load_validations = @validations.reject(&:deferred?)
      end

      def validate_pre_load
        run_validators(@pre_load_validations)
      end

      def validate_post_load
        run_validators(@post_load_validations)
      end

      def run_validators(validators = [])
        @errors.clear
        validators.each do |validator|
          result = validator.run(@sheet)

          unless result.success?
            @errors[validator.namespace] = validator.errors
            break
          end
        end

        valid?
      end

      def valid?
        @errors.empty?
      end
    end
  end
end
