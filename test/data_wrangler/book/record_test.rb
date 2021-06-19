# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Book
    class MockSheet < BasicObject
      attr_accessor :key_headers

      def initialize
        @key_headers = ["File Name", "File Type"]
      end

      def autofill_record
        nil
      end

      def headers
        ["File Name", "File Type", "MIME"]
      end

      def namespace
        "Sheet1"
      end

      def record_validations
        []
      end

      # Basic, do-nothing config
      def config_for_header(header)
        ::DataWrangler::Configuration::Field.new(header)
      end
    end

    class RecordTest < Minitest::Test
      def setup
      end

      def test_primary_key_is_not_nil
        sheet = MockSheet.new
        subject = _new_record(data: ["test1", "jpg", "image/jpeg"], sheet: sheet)
        subject._configure_cells
        assert_match(/\A(-*?\d+?):(-*?\d+?)\Z/, subject.primary_key)
      end

      def test_primary_key_is_nil_when_sheet_has_no_configured_key_headers
        sheet = MockSheet.new
        sheet.key_headers = []

        subject = _new_record(data: ["test1", "jpg", "image/jpeg"], sheet: sheet)
        subject._configure_cells
        assert subject.primary_key.nil?
      end

      def _new_record(sheet:, position: 1, data: [])
        DataWrangler::Book::Record.new([data, position], sheet)
      end
    end
  end
end
