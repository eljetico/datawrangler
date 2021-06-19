# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Transformers
    module Field
      class SplitStringTest < Minitest::Test
        def setup
        end

        def test_accepts_literal_value_and_returns_result_instance
          subject = _transformer
          result = subject.transform("mars, jupiter, mercury")
          assert result.success?
          assert_equal(%w[mars jupiter mercury], result.chainable_value)
        end

        def test_accepts_multiple_separators
          subject = _transformer({"separator" => ",;|"})
          result = subject.transform("mars; jupiter, mercury|pluto")
          assert result.success?
          assert_equal(%w[mars jupiter mercury pluto], result.chainable_value)
        end

        def test_override_default_separator
          subject = _transformer({"separator" => "|"})
          result = subject.transform("mars | jupiter ")
          assert_equal(%w[mars jupiter], result.chainable_value)
        end

        def test_handles_array_value
          subject = _transformer
          result = subject.transform(%w[one two])
          assert_equal(%w[one two], result.chainable_value)
        end

        def _transformer(config = {})
          DataWrangler::Transformers::Field::SplitString.new(config)
        end
      end
    end
  end
end
