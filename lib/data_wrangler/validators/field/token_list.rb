# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Optionally trim and validate Array value
      class TokenList < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "min" => 0,
            "max" => 1000,
            "trim" => false
          }.deep_merge(config || {})

          super(config)
        end

        def validate(value = [])
          c_value = Array(value).flatten.compact
          list = _possibly_trim_values(c_value)
          token_count = list.length

          if out_of_bounds(token_count)
            DataWrangler::Validators::Result.failure(value, error_message(token_count))
          else
            DataWrangler::Validators::Result.success(value, list)
          end
        end

        def error_message(value)
          @config["error_message"] || "token count must be between #{@config["min"]} " \
            "and #{@config["max"]} (#{value} received)"
        end

        def out_of_bounds(token_count)
          token_count < @config["min"] || token_count > @config["max"]
        end

        def _possibly_trim_values(list)
          return list unless @config["trim"]

          list.slice(0, @config["max"])
        end
      end
    end
  end
end
