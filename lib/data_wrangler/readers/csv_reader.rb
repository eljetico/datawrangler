# frozen_string_literal: true

require_relative "text_reader"
# require_relative 'decoded_text'

module DataWrangler
  module Readers
    # CSV-specific reader
    class CsvReader < TextReader
      require "csv"

      def read_rows
        csv_read.each_with_index do |row, i|
          next if row.empty?

          data = convert_row(row, i + 1)
          yield data if block_given?
        end
      rescue => e
        raise "Data read error: #{e.message}"
      end

      def csv_read
        @encoding = detect_text_file_encoding(@file_path)
        CSV.read(@file_path, encoding: @encoding)
      end
    end
  end
end
