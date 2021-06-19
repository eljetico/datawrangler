# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Transformers
    module Field
      class BaseTest < Minitest::Test
        def setup
        end

        def test_chained_transformers
          result = _downcase_transformer.run("Mars, Jupiter, MERCURY")
          result = _split_string_transformer.run(result)
          assert result.success?
          assert_equal(%w[mars jupiter mercury], result.sanitized)
          assert_equal("Mars, Jupiter, MERCURY", result.original_value)
        end

        def _downcase_transformer
          DataWrangler::Transformers::Field::Downcase.new
        end

        def _split_string_transformer(config = {})
          DataWrangler::Transformers::Field::SplitString.new(config)
        end
      end
    end
  end
end
