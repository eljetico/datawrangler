# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Conformers
    module Field
      class ExtractDateTest < Minitest::Test
        def setup
          @invalid_date_string = "2001-02-29"
        end

        def teardown
        end

        def test_returns_failure_result_with_bad_date
          result = _conformer.conform(@invalid_date_string)
          assert result.failure?
          assert_match(/invalid date/, result.errors[0])
        end

        def test_returns_success_result
          result = _conformer.conform("1970-01-01")
          assert result.success?
          assert result.sanitized.respond_to?(:to_date)
        end

        def _conformer(options = {})
          DataWrangler::Conformers::Field::ExtractDate.new(options)
        end
      end
    end
  end
end
