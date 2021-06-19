# frozen_string_literal: true

require_relative "../test_helper"

module DataWrangler
  class BookTest < Minitest::Test
    def setup
    end

    def test_xlsx_reader_single_sheet
      book = DataWrangler::Book::Base.new(xlsx_path("one_sheet_columnar.xlsx"))
      assert_equal 1, book.sheets.length
      assert book.sheets[0].is_a?(DataWrangler::Book::Sheet)
      assert_equal "Sheet 1", book.sheets[0].name
    end

    def test_transpose_to_columns
      book = DataWrangler::Book::Base.new(xlsx_path("one_sheet_by_row.xlsx"))
      sheet = book.sheets[0]

      sheet.to_columns
      columns = sheet.columns
      # assert_equal 0, sheet.rows.length
      assert_equal "Name", columns[0].cells[0].value
      assert_equal "Mickey Mouse", columns[1].cells[0].value
    end
  end
end
