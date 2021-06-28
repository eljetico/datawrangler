# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Readers
    class XlsxReaderTest < Minitest::Test
      def setup
        @reader = DataWrangler::Readers::XlsxReader.new
      end

      def test_single_sheet
        file = xlsx_path("one_sheet_columnar.xlsx")
        @reader.parse(file)
        data = @reader.data
        sheet = data[0]

        assert_equal 1, data.length # pages
        assert_equal "Sheet 1", sheet[:name]
        assert_equal 3, sheet[:rows].length # rows
        assert_equal 17, sheet[:rows][0].length # line_no + columns
      end

      def test_multi_sheet
        file = xlsx_path("three_sheets_columnar.xlsx")
        @reader.parse(file)
        data = @reader.data
        sheet1 = data[0]
        sheet2 = data[1]

        assert_equal 3, data.length # pages
        assert_equal 8, sheet1[:rows].length # rows
        assert_equal 9, sheet2[:rows][0].length # line_no + columns
      end
    end
  end
end
