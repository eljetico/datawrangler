# frozen_string_literal: true

require_relative "record"

module DataWrangler
  module Book
    # Encapsulate row of cells
    class Column < DataWrangler::Book::Record
      def format
        "column"
      end
    end
  end
end
