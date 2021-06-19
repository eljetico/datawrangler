# frozen_string_literal: true

require "spreadsheet"
require_relative "general_reader"

module DataWrangler
  module Readers
    # Handle .xls files
    class XlsReader < GeneralReader
      def parse(file_path)
        @file_path = file_path
        @workbook = Spreadsheet.open(@file_path)
        @sheets = @workbook.worksheets

        parse_file
      end

      def row_as_array(row)
        row.to_a.map { |value| clean_value(value) }
      end
    end
  end
end
