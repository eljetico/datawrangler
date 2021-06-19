# frozen_string_literal: true

require_relative "general_reader"

module DataWrangler
  module Readers
    # Abstract text reader class (see TxtReader/CsvReader)
    class TextReader < GeneralReader
      def detect_text_file_encoding(filepath)
        detection = @encoding_detector.detect(File.read(filepath))
        detection[:encoding]
      end

      def detect_line_separator
        file = File.open(@file_path)
        file.gets[/(\r|\n)/]
      end

      def parse(file_path)
        @file_path = file_path

        parse_file
      end

      def parse_file
        @data[0] = {
          name: "Sheet 1",
          rows: []
        }

        read_rows do |row|
          @data[0][:rows] << row unless empty_row?(row)
        end
      end
    end
  end
end
