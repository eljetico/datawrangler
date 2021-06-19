# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Readers
    class TxtReaderTest < Minitest::Test
      def setup
        @reader = DataWrangler::Readers::TxtReader.new
      end

      def test_single_sheet
        file = txt_path("simple_text.txt")
        @reader.parse(file)
        data = @reader.data

        assert_equal 1, data.length # pages
        assert_equal 3, data[0][:rows].length # rows
        assert_equal 3, data[0][:rows][0][0].length # columns
      end
    end
  end
end
