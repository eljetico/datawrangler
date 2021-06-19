# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Optionally trim and validate character length of supplied value
      class CharacterLength < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "min" => 0,
            "max" => 2000,
            "trim" => false
          }.deep_merge(config || {})

          super(config)
        end

        def validate(value)
          c_value = _possibly_trim_value(value)
          length = c_value.length

          if length < @config["min"] || length > @config["max"]
            DataWrangler::Validators::Result.failure(value, [error_message(length)])
          else
            DataWrangler::Validators::Result.success(value, c_value)
          end
        end

        def error_message(length)
          @config["error_message"] || "character count must be between #{@config["min"]}" \
            " and #{@config["max"]} (#{length} received)"
        end

        def _possibly_trim_value(value)
          value = value.to_s
          value = value.slice(0, @config["max"]).rstrip if @config["trim"]
          value
        end
      end
    end
  end
end
