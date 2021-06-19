# frozen_string_literal: true

require_relative "formatter/sheet"
require_relative "formatter/record"

module DataWrangler
  # Reformat Book/Sheet/Record/Cell data according to supplied configuration
  # This enriches the extracted objects with configuration information,
  # EG cells each contain field configuration, auto-filled value, header etc
  module Formatter
    # Base transformer
    class Base
      attr_reader :book, :config, :errors

      def initialize(book, config = nil)
        @config = initialize_config(config)
        @book = book
        @errors = []
      end

      def configure
        @errors.clear

        # Configure our sheets of data
        @book.sheets.each do |sheet| # these are raw rows of data
          next if @config.ignore_sheet?(sheet.name)

          formatter = DataWrangler::Formatter::Sheet.new(sheet, @config)

          unless formatter.configured?
            @errors.push("Cannot configure #{sheet.name} for transform: at least 2 headers must match required")
          end
        end

        successful?
      end

      def successful?
        @errors.empty?
      end

      private

      def initialize_config(config = nil)
        configurator = DataWrangler::Configuration::Book
        config.respond_to?(:sheet_configurations) ? config : configurator.new(config)
      end
    end
  end
end
