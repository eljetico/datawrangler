# frozen_string_literal: true

require "forwardable"
require_relative "cell"

module DataWrangler
  module Book
    # Encapsulate row of cells
    class Record
      attr_reader :cells, :errors, :position

      extend Forwardable
      def_delegators :@sheet,
        :autofill_record,
        :key_headers

      def initialize(data_col, sheet = nil)
        @data = data_col[0]
        @errors = nil
        @position = data_col[1]
        @cells = @data.map { |data_cell| Cell.new(data_cell, self) }
        @sheet = sheet
      end

      def autofill_record?
        position == @sheet.configuration.autofill_position
      end

      def clean_cells
        @cells.reject(&:ignore?)
      end

      def empty?
        @cells.empty?
      end

      # Allow injection of headers for testing
      def primary_key(headers = nil)
        @primary_key ||= begin
          headers ||= key_headers
          return nil if headers.compact.empty?

          _extract_primary_key(headers)
        end
      end

      def _configure_cells
        @sheet.headers.each_with_index do |header, index|
          cell = cells[index]
          next if cell.nil?

          cell_config = @sheet.config_for_header(header)

          if cell_config.nil?
            cell.ignore = true
            next
          end

          cell.configuration = cell_config # Need to set the configuration
          cell.header.actual = header
          cell.value = extract_value(cell, index, cell_config)
        end
      end

      def _extract_primary_key(headers)
        clean_cells.select { |cell| headers.include?(cell.sanitized_header) }.map do |cell|
          cell.value.to_s.hash
        end.join(":")
      end

      def extract_value(cell, index, field_config)
        return cell.value unless cell.empty?

        return nil unless field_config.autofill? # defaults to true

        @sheet.autofill_record.nil? ? nil : @sheet.autofill_record.cells[index].value
      end

      def validations
        @sheet.record_validations
      end
    end
  end
end
