# frozen_string_literal: true

require "forwardable"

require_relative "column"
require_relative "row"

module DataWrangler
  module Book
    # Encapsulate sheet of rows. Begin life as rows of cells parsed from supplied
    # Reader-originated data-sheet. Following instantiation, configuration rules
    # may require vertical data: call 'to_columns' to reformat the data into
    # a collection of Column rather than Row objects
    class Sheet
      attr_accessor :autofill_record,
        :book,
        :configuration

      attr_reader :columns,
        :errors,
        :downcased_headers,
        :headers,
        :header_configs

      extend Forwardable
      def_delegators :@configuration,
        :config_for_header,
        :key_headers,
        :namespace,
        :position_prefix,
        :record_validations,
        :required_fields

      def initialize(data_sheet)
        @data_sheet = data_sheet

        # These are set via DataWrangler::Formatter::Sheet
        @autofill_record = nil
        @headers = nil
        @configuration = nil

        # Placehold for vertical format sheets
        @columns = []
      end

      # Access rows/column using this method exclusively
      def data
        vertical? ? columns : rows
      end

      def data_at_index(index)
        data[index]
      end

      def horizontal?
        rows.any?
      end

      def vertical?
        columns.any?
      end

      def name
        @data_sheet[:name]
      end

      def records
        @records ||= data.reject { |d| ignore_record?(d) }
      end

      def rows
        @rows ||= @data_sheet[:rows].map! { |data_row|
          instantiate_record(Row, data_row)
        }
      end

      def set_headers(headers)
        @headers = headers.freeze # from file
        @downcased_headers = @headers.map { |h| h.to_s.downcase }.freeze
        @header_configs = @headers.map.with_index { |h, i|
          config_for_header(@downcased_headers[i])
        }
      end

      # Post-process rows into columns if required
      def to_columns
        @columns = transpose_to_columns
      end

      def validate
        ok = true
        @errors = {}

        records.each do |record|
          unless record.validate
            @errors[record.position] = record.errors
            ok = false
          end
        end
        ok
      end

      private

      # Autofill record is asserted during configuration phase
      # by Formatter::Sheet
      def autofill_record?(record)
        return false if @autofill_record.nil?

        record.position == @autofill_record.position
      end

      def is_header?(data)
        @configuration.header_position == data.position
      end

      def ignore_record?(data)
        return true if is_header?(data)

        return true if autofill_record?(data)

        @configuration.send("ignore_#{data.format}?", data.position)
      end

      def instantiate_record(type, data)
        type.new(data, self)
      end

      # THIS IS DESTRUCTIVE: REMOVES @rows
      def transpose_to_columns
        cols = []

        rows.each_with_index do |r, _ri|
          next if r.empty?

          r.cells.each_with_index do |c, ci|
            column = cols[ci] || [ci + 1]
            column.push(c) # Cell can accept another Cell
            cols[ci] = column
          end
        end

        @rows.clear
        cols.map! { |data_col| instantiate_record(Column, data_col) }
      end
    end
  end
end
