# frozen_string_literal: true

require_relative "base"

module DataWrangler
  module Transformers
    module Field
      # Base class to apply configured transformations to cell value
      # Subclass this transformer with specific functionality, eg
      # parse strings to array
      class SplitString < DataWrangler::Transformers::Field::Base
        attr_reader :separator

        def initialize(config = nil)
          super(config)

          @separator = @config.fetch("separator", ",")
        end

        def transform(value = nil)
          _success(value, parse_list_values(value, @separator))
        end
      end
    end
  end
end
