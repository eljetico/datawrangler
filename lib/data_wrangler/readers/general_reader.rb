# frozen_string_literal: true

module DataWrangler
  module Readers
    # Abstract parser
    class GeneralReader
      attr_accessor :data, :header_map, :sheets, :sheets_headers
      attr_reader :encoding, :file_path

      def initialize
        @encoding_detector = CharlockHolmes::EncodingDetector.new

        @sheets = []
        @sheets_headers = []
        @data = []
        @header_map = []
      end

      # TODO: deprecate to 'Sanitizers'
      def clean_value(value)
        # value.is_a?(String) ? value.strip.gsub(/\A"|"\Z/, '') : value
        value
      end

      def empty_row?(data)
        data.compact.empty?
      end

      def parse_file
        @sheets.each_with_index do |s, i|
          @sheet = s
          @data[i] = {
            name: @sheet.respond_to?(:name) ? @sheet.name : "Sheet #{i + 1}",
            rows: []
          }

          read_rows do |row|
            @data[i][:rows] << row
          end
        end

        @sheets = nil # conserve memory
      end

      # Override in specific readers if required
      def read_rows
        line_no = 0

        @sheet.rows.each do |r|
          line_no += 1
          row = row_as_array(r)
          next if empty_row?(row)

          data = convert_row(row, line_no)
          yield data if block_given?
        end
      end

      # Returns [[cols|rows], line_no]
      def convert_row(row, line_no)
        [row.map { |value| clean_value(value) }, line_no]
      end
    end
  end
end
