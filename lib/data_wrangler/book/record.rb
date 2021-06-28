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
        @errors = nil
        @position = data_col.shift
        @cells = data_col.map { |data_cell| Cell.new(data_cell, self) }
        @sheet = sheet
      end

      def autofill_record?
        position == @sheet.configuration.autofill_position
      end

      def clean_cells
        @clean_cells ||= @cells.reject(&:ignore?)
      end

      def empty?
        @cells.empty?
      end

      # Allow injection of headers for testing
      def primary_key(headers = key_headers)
        @primary_key ||= begin
          # return nil if headers.compact.empty?
          return nil unless headers.any? # [nil, nil] returns 'empty'

          _extract_primary_key(headers)
        end
      end

      def _configure_cells
        @sheet.headers.each_with_index do |header, index|
          cell = cells[index]
          next if cell.nil?

          cell_config = @sheet.header_configs[index]

          if cell_config.nil?
            cell.ignore = true
            next
          end

          cell.configuration = cell_config # Need to set the configuration
          cell.header.actual = header
          assert_cell_value(cell, index)
        end
      end

      def _extract_primary_key(headers)
        clean_cells.select { |cell| headers.include?(cell.sanitized_header) }.map do |cell|
          cell.value.to_s.hash
        end.join(":")
      end

      def assert_cell_value(cell, index)
        return unless cell.empty?

        return unless cell.configuration.autofill? # defaults to true

        return if @sheet.autofill_record.nil?

        cell.value = @sheet.autofill_record.cells[index].value
      end

      def validations
        @sheet.record_validations
      end
    end
  end
end
