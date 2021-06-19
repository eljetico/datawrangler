# frozen_string_literal: true

module DataWrangler
  module Validators
    module Record
      # High-level wrapper for Record->Cells validation
      class Cells
        attr_reader :errors

        def initialize
          @errors = {}
        end

        def validate(record)
          @errors.clear
          record.cells.reject(&:ignore?).each do |cell|
            result = cell.validate
            @errors[cell.header] = result.errors unless result.success?
          end
          valid?
        end

        def valid?
          @errors.empty?
        end
      end
    end
  end
end
