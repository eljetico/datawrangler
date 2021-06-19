# frozen_string_literal: true

module DataWrangler
  module Conformers
    module Field
      # Try hard to extract a Date object from supplied value
      class ExtractDate < DataWrangler::Conformers::Field::Base
        def initialize(config = nil)
          config = {
            "formats" => ["%Y-%m-%d"]
          }.deep_merge(config || {})

          super(config)

          @formats = @config["formats"].uniq
        end

        def conform(value)
          return _success(value) if value.respond_to?(:to_date)

          @formats.each do |format|
            if (date = Date.strptime(value, format))
              return _success(date)
            end
          end

          _failure(value, error_message(value))
        rescue => e
          _failure(value, error_message(value, e.message))
        end

        def error_message(value, additional = nil)
          ["cannot extract date from #{value.class.name}:#{value}", additional].compact.join(" - ")
        end
      end
    end
  end
end
