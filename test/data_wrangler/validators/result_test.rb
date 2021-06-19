# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Validators
    class ResultTest < Minitest::Test
      def setup
      end

      def teardown
      end

      # We retain original_value for reference
      # but hand sanitized to combined validations
      def test_success_result_without_sanitized
        subject = success_result("test")
        assert_equal "test", subject.sanitized
        assert_equal "test", subject.original_value
        assert_equal "test", subject.chainable_value
        assert subject.errors.none?
      end

      def test_failure_result
        subject = failure_result("test", ["bad"])
        assert_nil subject.sanitized
        refute subject.errors.none?
      end

      private

      def success_result(o_value, sanitized = nil)
        DataWrangler::Validators::Result.success(o_value, sanitized)
      end

      def failure_result(o_value, errors)
        DataWrangler::Validators::Result.failure(o_value, errors)
      end
    end
  end
end
