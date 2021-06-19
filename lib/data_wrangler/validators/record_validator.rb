# frozen_string_literal: true

require_relative "field_validator"
require_relative "record/base"
require_relative "record/cells"

module DataWrangler
  module Validators
    # Handle overall validation for loaded Record
    class RecordValidator
      attr_reader :errors

      # Accepts pre-configured DataWrangler::Book::Record
      def initialize(record)
        @record = record
        @errors = {}
      end

      def validate
        @errors.clear
        _validate_cells && _validate_deferred
      end

      def _validate_cells
        @record.cells.reject!(&:ignore?).each do |cell|
          validator = DataWrangler::Validators::FieldValidator.new(cell)
          @errors[cell.header] = validator.errors unless validator.valid?
        end
        valid?
      end

      def _validate_deferred
        @record.validations.each do |validator|
          result = validator.validate(@record)
          @errors[validator.namespace] = validator.errors unless result
        end
        valid?
      end

      def valid?
        @errors.empty?
      end
    end
  end
end
