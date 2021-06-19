# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Validate dates between supplied ranges. Should be able to handle
      # both Date-like objects and strings which are parseable using supplied
      # formats
      class DateRange < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "from" => Date.new(2000, 1, 1),
            "to" => Date.today,
            "formats" => ["%Y-%m-%d"]
          }.deep_merge(config || {})

          super(config)

          @formats = @config["formats"].uniq
          @from = extract_date(@config["from"])
          @to = extract_date(@config["to"])
        end

        # Override this in subclasses with more capable means of extracting
        # dates from strings, objects etc
        #
        # Should raise configuration error when instantiating with misconfigured
        # dates. The error should be caught during validation
        def extract_date(value)
          return value if value.respond_to?(:to_date)

          @formats.each do |format|
            if (date = Date.strptime(value, format))
              return date
            end
          end

          nil
        rescue => e
          raise DataWrangler::Configuration::Error, e.message
        end

        def validate(value)
          c_value = extract_date(value)
          if _within_bounds(c_value)
            DataWrangler::Validators::Result.success(value, c_value)
          else
            DataWrangler::Validators::Result.failure(value, [error_message(value)])
          end
        rescue => _e
          _invalid_date_result(value)
        end

        def error_message(value)
          @config["error_message"] || "date must be between #{@to}" \
            " and #{@to} ('#{value}' received)"
        end

        def _invalid_date_result(value)
          errors = ["invalid date ('#{value}' received)"]
          DataWrangler::Validators::Result.failure(value, errors)
        end

        def _within_bounds(value)
          value >= @from && value <= @to
        end
      end
    end
  end
end
