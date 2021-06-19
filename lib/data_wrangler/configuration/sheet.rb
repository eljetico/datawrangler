# frozen_string_literal: true

require_relative "validatable"
require_relative "field"

module DataWrangler
  module Configuration
    # Handle sheet-based configuration
    # rubocop:disable Metrics/ClassLength
    class Sheet
      include Validatable

      MIN_MATCHING_HEADER_COUNT = 2

      attr_reader :namespace,
        :autofill_position,
        :field_map,
        :header_position,
        :ignore_rows,
        :ignore_columns,
        :parse_by

      attr_accessor :key_headers, :record_validations, :sheet_validations

      def config_for_header(header)
        @field_map.fetch(header.to_s.downcase, nil)
      end

      # Humanized column number
      def ignore_column?(position)
        @ignore_columns.include?(position)
      end

      # Humanized row number
      def ignore_row?(position, record = [])
        return true if @ignore_rows.include?(position)
        false
      end

      def initialize(namespace, config = nil)
        @namespace = namespace
        _load_sheet_config(config)
        _load_field_map
      end

      # Optimistically attempt to extract headers from the supplied data
      # If no 'required_fields' are configured, return the headers as found
      # in data.
      def extract_headers_from_data(data_sheet)
        return [] if data_sheet.data.empty?

        header_cells = _header_cells_from_data(data_sheet)
        headers = header_cells.map(&:value).compact

        required = _downcase_array(required_field_aliases).uniq
        found = _downcase_array(headers)

        # If no configured required headers (eg default configuration), we'll pass through headers
        return headers if required.empty?

        matching_count = (found & required).length
        matching_count >= MIN_MATCHING_HEADER_COUNT ? headers : []
      end

      def parse_by_column?
        @parse_by_column ||= @parse_by.match(/col/i)
      end

      # Ignore fields if they are not permitted (unless required_fields is
      # empty, in which case all fields are permitted)
      def permitted_field_names
        @permitted_field_names ||= @field_map.keys.uniq.sort
      end

      def position_prefix
        @position_prefix ||= (parse_by_column? ? "column" : "row")
      end

      def required_fields
        @required_fields ||= @fields.values.each_with_object([]) do |f_config, array|
          array.push(f_config.field_name) if f_config.required?
        end
      end

      def required_field_aliases
        @required_field_aliases ||= @field_map.each_with_object([]) do |(f_name, f_config), array|
          array.push(f_name) if f_config.required?
        end
      end

      def required_header_map
        required_fields.each_with_object({}) do |required, hash|
          aliases = Array([required, field_map[required].aliases])
          hash[required] = aliases.flatten.compact.uniq.map(&:downcase)
          hash
        end
      end

      private

      # Create a dictionary of all permissible header values (including
      # aliases) linked to respective field configurator
      def _load_field_map
        @field_map = @fields.values.each_with_object({}) do |f_config, hash|
          f_config.valid_headers.each do |f_h|
            hash[f_h] = f_config
          end
          hash
        end
      end

      def _load_sheet_config(config = nil)
        options = default_config.merge(config || {})

        _load_top_level_config(options)

        @fields = _load_field_config(options)
        @record_validations = _load_record_config(options)
        @sheet_validations = _load_self_validations(options)

        @key_headers = _load_key_headers(options)
      end

      def _load_field_config(options)
        options.fetch("fields", {}).each_with_object({}) do |(f_name, f_config), hash|
          hash[f_name] = DataWrangler::Configuration::Field.new(f_name, f_config)
          hash
        end
      end

      # Return an array containing one or more headers constituting our
      # 'primary key' for duplicate checks.
      # Respect top-level declaration under 'key_fields' or, map from
      # loaded @fields configuration, raising an error if cannot configure
      def _load_key_headers(options)
        configured = options.fetch("key_fields") do
          @fields.select { |_name, field| field.key_field? }
        end

        # Ensure we have an array (may be empty)
        Array(configured).flatten
      end

      def _load_record_config(options)
        options.fetch("record_validations", []).map do |v_config|
          load_record_validator(@namespace, v_config)
        end.compact
      end

      def _load_top_level_config(options)
        @parse_by = options.fetch("parse_by", "row").downcase
        @header_position = options.fetch("header_position", 1)
        @ignore_rows = options.fetch("ignore_rows", [])
        @ignore_columns = options.fetch("ignore_columns", [])
        @autofill_position = options.fetch("autofill_position", nil)
      end

      def _load_self_validations(options)
        options.fetch("validations", []).map do |v_config|
          load_sheet_validator(@namespace, v_config)
        end
      end

      # Note references to 'row' & 'column' are 'humanized' rather than indices!
      def default_config
        {
          "parse_by" => "row",
          "header_position" => 1, # could be row or column
          "ignore_rows" => [],
          "ignore_columns" => [],
          "fields" => {}
        }
      end

      def _configuration_error(msg)
        raise DataWrangler::Configuration::Error, msg
      end

      def _downcase_array(values)
        values.map { |v| v.to_s.downcase }
      end

      def _header_cells_from_data(data_sheet)
        h_index = (header_position || 1) - 1
        parse_by_column? ? data_sheet.rows.map { |r| r.cells[h_index] } : data_sheet.rows[h_index].cells
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
