# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      class NumberRangeTest < Minitest::Test
        def setup
        end

        def teardown
        end

        def test_validation
          subject = _new_validator({"min" => 2, "max" => 10})
          result = subject.run(3)
          assert result.valid?
        end

        def test_below_minimum
          subject = _new_validator({"min" => 2, "max" => 3})
          result = subject.run(1)
          refute result.valid?
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::NumberRange.new(options)
        end
      end
    end
  end
end
