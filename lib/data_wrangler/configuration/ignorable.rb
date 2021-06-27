# frozen_string_literal: true

module DataWrangler
  module Configuration
    # Mixin methods for ignoring rows/columns as configured
    # Note, these methods will likely be called for every row/column,
    # so perhaps good targets for optimization
    module Ignorable
      # Humanized column numbers
      def ignore_column?(position, record = [])
        ignored_column_position?(position) || ignored_column_contents?(record)
      end

      # Humanized row numbers
      def ignore_row?(position, record = [])
        ignored_row_position?(position) || ignored_row_contents?(record)
      end

      def ignored_column_contents?(record)
        _ignore_records_containing(record, @ignore_columns_containing)
      end

      def ignored_column_position?(position)
        _ignore_record_numbers(position, @ignore_column_numbers)
      end

      def ignored_row_contents?(record)
        _ignore_records_containing(record, @ignore_rows_containing)
      end

      def ignored_row_position?(position)
        _ignore_record_numbers(position, @ignore_row_numbers)
      end

      private

      def _ignore_record_numbers(position, record_numbers)
        record_numbers.include?(position)
      end

      def _ignore_records_containing(record, records_containing)
        # Creates 2 new objecta (albeit unretained) on each invocation, but
        # this profiled faster than using short-circuited '.each { |field| ... }'
        (records_containing & record).any?
      end

      def _load_ignore_record_config(options)
        @ignore_record_contents_cache = {}

        ["column", "row"].each do |rec|
          config = options.fetch("ignore_#{rec}s", {})

          # Create instance variables
          instance_variable_set("@ignore_#{rec}_numbers", config.fetch("numbers", []))
          instance_variable_set("@ignore_#{rec}s_containing", config.fetch("containing", []))
        end
      end
    end
  end
end
