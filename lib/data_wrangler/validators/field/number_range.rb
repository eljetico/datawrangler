# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Optionally trim and validate character length of supplied value
      class NumberRange < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "min" => 0,
            "max" => 1
          }.deep_merge(config || {})

          super(config)
        end

        def validate(value)
          value = value.to_i

          if value < @config["min"] || value > @config["max"]
            DataWrangler::Validators::Result.failure(value, error_message(value))
          else
            DataWrangler::Validators::Result.success(value)
          end
        end

        def error_message(value)
          @config["error_message"] || "number must be between #{@config["min"]} " \
            "and #{@config["max"]} (#{value} received)"
        end
      end
    end
  end
end
