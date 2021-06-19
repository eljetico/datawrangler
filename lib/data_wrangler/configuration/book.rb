# frozen_string_literal: true

require_relative "sheet"

module DataWrangler
  module Configuration
    class Error < StandardError; end

    # Overall configuration class
    class Book
      # options can be a Hash, Pathname or String filepath
      def initialize(options = nil, key: nil)
        options = handle_options(options) || default_options
        config = options.fetch(key) { options }
        @ignore_sheet_names = extract_ignore_sheet_names(config)
        @sheets = extract_sheet_configuration(config)
      end

      def ignore_sheet?(sheet_name)
        @ignore_sheet_names.include?(sheet_name.downcase)
      end

      def sheet_configurations
        @sheets
      end

      private

      def extract_ignore_sheet_names(options)
        options.fetch("ignore_sheet_names", []).map(&:downcase).uniq
      end

      def extract_sheet_configuration(options)
        options.fetch("sheets", {}).each_with_object([]) do |(entity, config), array|
          array.push(DataWrangler::Configuration::Sheet.new(entity, config))
        end
      end

      def default_options
        {
          "ignore_sheet_names" => [],
          "sheets" => {
            "default" => {
              "parse_by" => "row",
              "fields" => {}
            }
          }
        }
      end

      def handle_options(options)
        return options if options.nil? || options.respond_to?(:keys)

        options = options.to_path if options.respond_to?(:to_path)
        options = options.to_str

        YAML.load_file(options)
      end
    end
  end
end
