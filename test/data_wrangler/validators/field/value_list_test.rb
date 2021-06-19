# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      class ValueListTest < Minitest::Test
        def setup
        end

        def teardown
        end

        def test_validation
          subject = _new_validator({"values" => [1, 2, 3]})
          result = subject.run(3)
          assert result.valid?
        end

        def test_not_listed
          subject = _new_validator({"values" => [1, 2, 3]})
          result = subject.run(nil)
          refute result.valid?
        end

        def test_case_sensitive
          subject = _new_validator({"values" => %w[one two THREE], "case_sensitive" => true})
          result = subject.run("three")
          refute result.valid?

          result = subject.run("THREE")
          assert result.valid?
        end

        def test_case_insensitive
          subject = _new_validator({"values" => %w[one two THREE]})
          result = subject.run("three")
          assert result.valid?
          assert_equal "THREE", result.sanitized
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::ValueList.new(options)
        end
      end
    end
  end
end
