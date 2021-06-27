# frozen_string_literal: true

module DataWrangler
  module Formatter
    # Potentially transforms a Book::Sheet and configures with
    # auto-discovered Configuration::Sheet instance
    class Sheet
      attr_reader :errors, :headers

      def initialize(data_sheet, config)
        @data_sheet = data_sheet
        @errors = []
        configure(config)
      end

      def configure(config)
        @configuration = nil
        @errors.clear

        config.sheet_configurations.each do |c_sheet|
          optimistically_configure(c_sheet)
          break if configured?
        end
      end

      def configured?
        !@configuration.nil?
      end

      def data
        @data_sheet.data
      end

      def configure_records(sheet)
        # This needs to happen before Cells are configured
        sheet.autofill_record = autofill_record
        sheet.records.each do |record|
          f_record = DataWrangler::Formatter::Record.new(record)
          f_record.configure
        end
      end

      def configure_data_sheet
        @data_sheet.headers = @headers
        @data_sheet.configuration = @configuration
        configure_records(@data_sheet)
      end

      def namespace
        configured? ? @configuration.namespace : nil
      end

      def optimistically_configure(config)
        @headers = extract_headers(config)
        return unless @headers.any?

        @configuration = config
        possibly_reformat_sheet
        configure_data_sheet
      end

      def possibly_reformat_sheet
        return unless @configuration.parse_by_column?

        @data_sheet.to_columns
      end

      def extract_headers(config)
        config.extract_headers_from_data(@data_sheet)
      end

      def autofill_record
        return nil if @configuration.autofill_position.nil?

        data.find { |d|
          d.position == @configuration.autofill_position
        }
      end
    end
  end
end
