# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      class CharacterLengthTest < Minitest::Test
        def setup
        end

        def teardown
        end

        def test_validation
          subject = _new_validator({"min" => 2, "max" => 10})
          result = subject.run("test")
          assert result.valid?
        end

        def test_max_length_validation
          subject = _new_validator({"min" => 2, "max" => 3})
          result = subject.run("test")
          refute result.valid?
        end

        def test_min_length_validation
          subject = _new_validator({"min" => 5, "max" => 10})
          result = subject.run("test")
          refute result.valid?
          assert_equal(
            "character count must be between 5 and 10 (4 received)",
            result.error_string
          )
        end

        def test_trim_with_validation
          subject = _new_validator({"min" => 1, "max" => 3, "trim" => true})
          result = subject.run("test")
          assert result.valid?
          assert_equal "tes", result.sanitized
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::CharacterLength.new(options)
        end
      end
    end
  end
end
