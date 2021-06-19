# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Transformers
    module Field
      class DowncaseTest < Minitest::Test
        def setup
        end

        def test_accepts_nil_values
          subject = _transformer
          result = subject.transform(nil)
          assert result.success?
          assert_nil result.chainable_value
        end

        def test_accepts_string_values
          subject = _transformer
          result = subject.transform("Mars")
          assert result.success?
          assert_equal "mars", result.chainable_value
        end

        def test_accepts_array_values
          subject = _transformer
          result = subject.transform(%w[Mars JUPITER MercurY])
          assert result.success?
          assert_equal(%w[mars jupiter mercury], result.chainable_value)
        end

        def _transformer
          DataWrangler::Transformers::Field::Downcase.new
        end
      end
    end
  end
end
