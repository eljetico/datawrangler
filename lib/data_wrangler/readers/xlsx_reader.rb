# frozen_string_literal: true

require "creek"
require_relative "general_reader"

module DataWrangler
  module Readers
    # Handle .xlsx files
    class XlsxReader < GeneralReader
      def parse(filepath)
        @workbook = Creek::Book.new(filepath)
        @sheets = @workbook.sheets

        parse_file
      end

      # Workarounds for Creek
      def row_as_array(row)
        return [] if row.nil? || row.compact.empty?

        row.map { |_k, value| clean_value(value) }
      end

      # Creek!
      def read_rows
        @sheet.rows.each do |r|
          next if r.empty?

          line_no = creek_get_line_number(r) # creek ignores empty rows
          row = row_as_array(r)

          next if empty_row?(row)

          data = convert_row(row, line_no)
          yield data if block_given?
        end
      rescue => e
        raise "Data read error: #{e.message}"
      end

      # Creek!
      def creek_get_line_number(row)
        k = row.keys.max
        k.scan(/\d+/).first.to_i
      end
    end
  end
end
