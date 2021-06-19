# frozen_string_literal: true

require "yaml"
require_relative "../test_helper"

module DataWrangler
  module Formatter
    class BaseTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_single_sheet_configuration
        config = editorial_config
        book = DataWrangler::Book::Base.new(xlsx_path("one_sheet_columnar.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        cell = book.data_at(0, 0, 0)
        assert_equal "asset path", cell.header.to_s
        assert_equal 1, cell.configuration.validators.length
      end

      def test_multi_sheet_configuration
        book = DataWrangler::Book::Base.new(xlsx_path("three_sheets_columnar.xlsx"))
        DataWrangler::Formatter::Base.new(book, creative_stills_config).configure

        result = book.data_at(0, 1, 0)
        assert_equal "Original Filename", result.header.to_s
        assert_equal "original filename", result.header.sanitized
        assert_equal "Date of Birth", book.data_at(1, 0, 2).header.to_s
      end

      def test_mixed_configuration
        book = DataWrangler::Book::Base.new(xls_path("three_sheet_mixed.xls"))
        DataWrangler::Formatter::Base.new(book, creative_video_config).configure

        assert_equal " Production Company:", book.data_at(0, 0, 3).header.to_s
      end
    end
  end
end
