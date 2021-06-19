# frozen_string_literal: true

require_relative "base"

module DataWrangler
  module Transformers
    module Field
      # Downcase the supplied string or array value(s)
      class Downcase < DataWrangler::Transformers::Field::Base
        def transform(value = nil)
          return DataWrangler::Validators::Result.success(nil) if value.nil?

          a_value = _downcaser(value)
          clean = value.is_a?(Array) ? a_value : a_value[0]
          _success(value, clean)
        end

        def _downcaser(value)
          Array(value).flatten.map { |v| v.to_s.downcase }
        end
      end
    end
  end
end
