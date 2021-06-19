# frozen_string_literal: true

module DataWrangler
  module Conformers
    module Field
      # Optionally trim and validate character length of supplied value
      class Boolean < DataWrangler::Conformers::Field::MappedValue
        def initialize(config = nil)
          config = {
            "map" => {
              true => ["Yes", "Y", true, 1],
              false => ["No", "N", false, 0]
            },
            "valid" => %w[Y N]
          }.deep_merge(config || {})

          super(config)
        end

        def error_message(value)
          @config["error_message"] || "must be either #{@config["valid"].join(" or ")} ('#{value}' received)"
        end
      end
    end
  end
end
