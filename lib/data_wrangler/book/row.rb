# frozen_string_literal: true

require_relative "record"

module DataWrangler
  module Book
    # Encapsulate row of cells
    class Row < DataWrangler::Book::Record
      def format
        "row"
      end
    end
  end
end
