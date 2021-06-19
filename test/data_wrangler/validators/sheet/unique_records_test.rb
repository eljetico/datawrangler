# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Sheet
      class UniqueRecordsTest < Minitest::Test
        def setup
          @wrangler = image_metadata_wrangler
          @sheet = @wrangler.book.sheets[0]
          @validator = DataWrangler::Validators::Sheet::UniqueRecords.new
        end

        def test_without_key_headers_raises_error
          exp = assert_raises DataWrangler::Configuration::Error do
            @sheet.configuration.key_headers = []
            @validator.validate(@sheet)
          end

          assert_match(/\AKey Field\(s\) must be specified/, exp.message)
        end

        def test_error_result_with_single_key_fields_and_duplicate_records
          @sheet.configuration.key_headers = ["file name"]
          assert @sheet.key_headers.any?
          result = @validator.validate(@sheet)
          refute result.success?
          assert_equal(["Record at row 3 duplicated at row(s) 4, 5"], result.errors)
        end

        def test_error_result_with_dual_key_fields_and_duplicate_records
          @sheet.configuration.key_headers = ["file name", "format"]
          assert @sheet.key_headers.any?
          result = @validator.validate(@sheet)
          refute result.success?
          assert_equal(["Record at row 3 duplicated at row(s) 4"], result.errors)
        end

        def test_no_error_with_triple_key_fields_and_duplicate_records
          key_fields = ["file name", "format", "title"]
          @sheet.configuration.key_headers = key_fields
          result = @validator.validate(@sheet)
          assert result.success?
        end
      end
    end
  end
end
