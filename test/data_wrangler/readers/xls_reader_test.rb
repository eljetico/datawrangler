# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Readers
    class XlsReaderTest < Minitest::Test
      def setup
        @reader = DataWrangler::Readers::XlsReader.new
      end

      def test_single_sheet
        file = xls_path("three_sheet_mixed.xls")
        @reader.parse(file)
        data = @reader.data

        assert_equal 6, data.length # pages
        assert_equal 8, data[1][:rows].length # rows
        assert_equal 5, data[2][:rows][0][0].length # columns
      end
    end
  end
end
