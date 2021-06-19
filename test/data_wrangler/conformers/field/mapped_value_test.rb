# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Conformers
    module Field
      class MappedValueTest < Minitest::Test
        def setup
        end

        def test_case_insensitive_by_default
          subject = _conformer
          result = subject.conform("io")
          assert result.success?
          assert_equal("moon", result.chainable_value)
        end

        def test_returns_value_when_specified
          subject = _conformer({"lookup" => "value"})
          result = subject.conform("mercury")
          assert result.success?
          assert_equal(%w[Mars Mercury Earth], result.chainable_value)
        end

        def test_case_sensitive_without_strict_passes_through_original_value
          subject = _conformer({"case_sensitive" => true})
          result = subject.conform("mercury")
          assert result.success?
          assert_equal("mercury", result.chainable_value)
        end

        def test_case_sensitive_with_strict_returns_failure
          subject = _conformer({"case_sensitive" => true, "strict" => true})
          result = subject.conform("mercury")
          assert result.failure?
          assert_equal("mercury", result.chainable_value)
        end

        def _conformer(supplied = nil)
          config = {
            "map" => {
              "planet" => %w[Mars Mercury Earth],
              "moon" => %w[Europa Io]
            }
          }.deep_merge(supplied || {})

          DataWrangler::Conformers::Field::MappedValue.new(config)
        end
      end
    end
  end
end
