# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Sheet
      class RequiredHeadersTest < Minitest::Test
        def setup
          @validator = DataWrangler::Validators::Sheet::RequiredHeaders.new
          @header_map = {
            "File Name" => ["File Name", "file name", "filename"],
            "Format" => %w[Format format],
            "Mime" => %w[Mime MIME mime]
          }
        end

        # This is difficult to test without setting up config, sheet etc
        # so we're just going to test the key method. Header map is generated
        # in Configuration::Sheet
        def test_no_missing_headers
          headers = ["File Name", "Format", "MIME"]
          result = @validator.list_missing_headers(headers, @header_map)
          assert result.success?
        end

        def test_missing
          headers = ["File Name", "Format"]
          result = @validator.list_missing_headers(headers, @header_map)
          refute result.success?
          assert_equal(["Mime header missing"], result.errors)
        end
      end
    end
  end
end
