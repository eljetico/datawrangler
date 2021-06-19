# frozen_string_literal: true

require_relative "text_reader"

module DataWrangler
  module Readers
    # Reader for tab-separated text files
    class TxtReader < TextReader
      def field_sep
        "\t"
      end

      def line_sep
        detect_line_separator
      end

      def text_file_encoding
        @encoding = detect_text_file_encoding(@file_path)
        @encoding
      end

      def read_rows
        line_no = 0

        begin
          File.open(@file_path, "r:#{text_file_encoding}").each(_sep = line_sep) do |line|
            line_no += 1
            row = line.chomp.split(field_sep)
            next if row.empty?

            data = convert_row(row, line_no)
            yield data if block_given?
          end
        rescue => e
          raise "Data read error on line #{line_no}: #{e.message}"
        end
      end
    end
  end
end
