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

      def initialize(data_col, sheet)
        @data = data_col[0]
        @errors = nil
        @position = data_col[1]
        @cells = @data.map { |data_cell| Cell.new(data_cell) }
        @sheet = sheet
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
        autofill_record = @sheet.autofill_record

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
          cell.value = extract_value(cell, index, cell_config, autofill_record)
        end
      end

      # def _configure_primary_key(sheet)
      #   @key_headers = sheet.key_headers
      #   @primary_key = @key_headers.empty? ? nil : _extract_primary_key(@key_headers)
      # end

      # This isn't entirely necessary
      # def _configure_validations(sheet)
      #   @validations = sheet.record_validations
      # end

      def _extract_primary_key(headers)
        clean_cells.select { |cell| headers.include?(cell.sanitized_header) }.map do |cell|
          cell.value.to_s.hash
        end.join(":")
      end

      def extract_value(cell, index, config, autofill_record)
        return cell.value unless cell.empty?

        return nil unless config.autofill?

        autofill_record.nil? ? nil : autofill_record.cells[index].value
      end

      def validations
        @sheet.record_validations
      end
    end
  end
end
