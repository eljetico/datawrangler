# frozen_string_literal: true

module DataWrangler
  module Formatter
    # Formats and configures each Book::Sheet::Record via its' Sheet parent
    class Record
      attr_reader :errors, :headers

      def initialize(record)
        @record = record
        @errors = []
        configure
      end

      def configure
        @record._configure_cells
      end
    end
  end
end
