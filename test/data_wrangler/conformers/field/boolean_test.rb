# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Conformers
    module Field
      class BooleanTest < Minitest::Test
        def setup
        end

        def teardown
        end

        def test_validation_boolean
          subject = _conformer({"valid" => %w[y n]})
          result = subject.run(true)
          assert result.valid?
          assert_equal true, result.sanitized
        end

        def test_validation_string
          subject = _conformer({"valid" => %w[y n]})
          result = subject.run("Yes")
          assert result.valid?
          assert_equal true, result.sanitized
        end

        def test_validation_string_falsey
          subject = _conformer({"valid" => %w[y n]})
          result = subject.run(0)
          assert result.valid?
          assert_equal false, result.sanitized
        end

        def _conformer(options)
          DataWrangler::Conformers::Field::Boolean.new(options)
        end
      end
    end
  end
end
