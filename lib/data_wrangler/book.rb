# frozen_string_literal: true

require_relative "readers"
require_relative "book/sheet"
require_relative "validators"

module DataWrangler
  module Book
    # Factory to handle multiple file types
    class Base
      attr_reader :errors

      def initialize(filepath, options = nil)
        @options = {}.merge(options || {})
        @filepath = filepath
        @reader = DataWrangler::Readers.for(@filepath, @options)
        @reader.parse(@filepath)
      end

      def sheets
        @sheets ||= @reader.data.map! { |data_sheet|
          sheet = DataWrangler::Book::Sheet.new(data_sheet)
          sheet.book = self
          sheet
        }
      end

      # Curry this function to return records, sheets etc
      def data_at(sheet_index, record_index, cell_index)
        @sheets[sheet_index].records[record_index].cells[cell_index]
      end

      def validate
        @errors = {}

        sheets.each do |sheet|
          validator = DataWrangler::Validations::SheetValidator.new(sheet)
          validator.validate
          @errors[sheet.namespace] = validator.errors unless validator.valid?
        end

        @errors.empty?
      end
    end
  end
end
