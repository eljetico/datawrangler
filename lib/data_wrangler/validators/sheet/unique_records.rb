# frozen_string_literal: true

module DataWrangler
  module Validators
    module Sheet
      # Subclass this validator for more specific Sheet-wide checks
      class UniqueRecords < DataWrangler::Validators::Sheet::Base
        def initialize(options = {})
          config = {
            "deferred" => true
          }.deep_merge(options)
          super(config)
        end

        def validate(sheet)
          _configuration_error(sheet) unless sheet.key_headers.any?
          _report_duplicate_records(sheet)
        end

        def _compile_record_positions(sheet)
          found_positions = Hash.new { |h, k| h[k] = [] }

          sheet.records.each do |record|
            primary_key = record.primary_key(sheet.key_headers)
            found_positions[primary_key].push(record.position)
          end

          found_positions
        end

        def _compiled_error_records(found_positions, position_prefix)
          found_positions.values.each_with_object([]) do |positions, ary|
            next unless positions.length > 1

            ary.push(_error_message(position_prefix, positions))
            ary
          end
        end

        def _report_duplicate_records(sheet)
          found_positions = _compile_record_positions(sheet)
          position_prefix = sheet.position_prefix
          errors = _compiled_error_records(found_positions, position_prefix)
          _result(errors)
        end

        def _configuration_error(sheet)
          msg = "Key Field(s) must be specified for '#{sheet.namespace}', " \
            "either as an array at top level under 'key_fields' or within one or more " \
            "fields with 'key_field' boolean"

          raise DataWrangler::Configuration::Error, msg
        end

        def _error_message(position_prefix, positions)
          "Record at #{position_prefix} #{positions.shift} duplicated at " \
            "#{position_prefix}(s) #{positions.join(", ")}"
        end
      end
    end
  end
end
