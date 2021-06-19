# frozen_string_literal: true

module DataWrangler
  module Validators
    module Sheet
      # Check for missing headers
      class RequiredHeaders < DataWrangler::Validators::Sheet::Base
        def validate(sheet)
          report_missing_headers(sheet)
        end

        # def deferred?
        #   false
        # end

        def list_missing_headers(headers, header_map)
          missing = []

          header_map.each_pair do |required, aliases|
            missing.push("#{required} header missing") if (headers & aliases).empty?
          end

          _result(missing)
        end

        def report_missing_headers(sheet)
          configuration = sheet.configuration
          normalized_headers = sheet.headers.dup.map(&:downcase)
          header_map = configuration.required_header_map
          list_missing_headers(normalized_headers, header_map)
        end
      end
    end
  end
end
