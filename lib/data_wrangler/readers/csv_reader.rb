# frozen_string_literal: true

require_relative "text_reader"
# require_relative 'decoded_text'

module DataWrangler
  module Readers
    # CSV-specific reader
    class CsvReader < TextReader
      require "csv"

      def read_rows
        line_no = 0

        csv_read.each do |row|
          line_no += 1
          next if row.empty?

          data = convert_row(row, line_no)
          yield data if block_given?
        end
      rescue => e
        raise "Data read error on line #{r_index}: #{e.message}"
      end

      def csv_read
        @encoding = detect_text_file_encoding(@file_path)
        CSV.read(@file_path, encoding: @encoding)
      end
    end
  end
end
