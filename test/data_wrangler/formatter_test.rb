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

      def test_autofill
        config = books_config
        book = DataWrangler::Book::Base.new(xlsx_path("books.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        sheet = book.sheets[0]
        refute sheet.autofill_record.nil?
        assert_equal 3, sheet.autofill_record.position

        assert_equal "Fiction", book.data_at(0, 0, 6).value
        assert_equal "Science Fiction", book.data_at(0, 0, 8).value

        sheet = book.sheets[1]
        assert sheet.autofill_record.nil?
      end

      def test_header_in_memory
        config = books_config
        book = DataWrangler::Book::Base.new(xlsx_path("books.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        cell1 = book.data_at(0, 0, 0)
        cell2 = book.data_at(0, 1, 0)

        assert_equal cell1.header, cell2.header
      end

      def test_books_book_list
        config = books_config
        book = DataWrangler::Book::Base.new(xlsx_path("books.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        cell = book.data_at(0, 0, 0)
        assert_equal "ISBN", cell.header.to_s
        assert_equal 1, cell.configuration.validators.length

        cell = book.data_at(0, 0, 4)
        assert_equal "AMER, EMEA, APAC", cell.value
      end

      def test_books_author_codes
        config = books_config
        book = DataWrangler::Book::Base.new(xlsx_path("books.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        cell = book.data_at(1, 0, 0)
        assert_equal "Code", cell.header.to_s
        assert_equal 1, cell.configuration.validators.length

        cell = book.data_at(1, 0, 1)
        assert_equal "Charles", cell.value
      end
    end
  end
end
