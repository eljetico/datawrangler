# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Optionally trim and validate character length of supplied value
      class ValueList < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "values" => [],
            "case_sensitive" => false
          }.deep_merge(config || {})

          super(config)
        end

        def validate(value)
          c_result = _extract_value(value)

          if c_result.nil?
            DataWrangler::Validators::Result.failure(value, error_message(value))
          else
            DataWrangler::Validators::Result.success(value, c_result)
          end
        end

        def error_message(value)
          @config["error_message"] || "must be one of #{@config.values.join(";")}" \
            " ('#{value}' received)"
        end

        def _extract_value(value)
          ignore_case = !@config["case_sensitive"]
          value = ignore_case && value.respond_to?(:downcase) ? value.downcase : value

          possibles = if ignore_case
            @config["values"].map do |v|
              v.respond_to?(:downcase) ? v.downcase : v
            end
          else
            @config["values"]
          end

          index = possibles.index(value)
          return nil if index.nil?

          @config["values"][index]
        end
      end
    end
  end
end
