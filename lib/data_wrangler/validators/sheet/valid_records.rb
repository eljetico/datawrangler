# frozen_string_literal: true

module DataWrangler
  module SheetValidatorTest
    module Sheet
      # Subclass this validator for more specific Sheet-wide checks
      class ValidRecords < DataWrangler::Validators::Sheet::Base
        def validate(sheet)
          d_errors = {}
          record_prefix = sheet.vertical? ? "column" : "row"

          sheet.records.each do |record|
            identifier = "#{record_prefix} #{record.position}"
            validator = DataWrangler::Validators::RecordValidator.new(record)
            validator.validate(record)
            d_errors[identifier] = validator.errors unless validator.valid?
          end

          _result(d_errors)
        end

        def _compile_record_positions(sheet)
          found_positions = Hash.new { |h, k| h[k] = [] }

          sheet.records.each do |record|
            primary_key = record.primary_key(sheet.key_headers)
            found_positions[primary_key].push(record.position)
          end

          found_positions
        end
      end
    end
  end
end
