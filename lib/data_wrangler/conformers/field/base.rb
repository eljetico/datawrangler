# frozen_string_literal: true

require_relative "../../field_processor"
require_relative "../../validators/result"

module DataWrangler
  module Conformers
    module Field
      # Base class to apply configured transformations to cell value
      # Subclass this transformer with specific functionality, eg
      # parse strings to array
      class Base < DataWrangler::FieldProcessor
        def initialize(config = {})
          super(config)
        end

        def process_value(value)
          conform(value)
        end
      end
    end
  end
end
