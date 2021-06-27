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

      def test_books_book_list
        config = books_config
        book = DataWrangler::Book::Base.new(xlsx_path("books.xlsx"))
        DataWrangler::Formatter::Base.new(book, config).configure

        cell = book.data_at(0, 0, 0)
        assert_equal "ISBN", cell.header.to_s
        assert_equal 1, cell.configuration.validators.length
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
