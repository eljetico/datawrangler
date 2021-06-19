# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    # Returns an invalid result with generic error
    class FalseValidator < DataWrangler::Validators::Field::Base
      def validate(value = nil)
        string = value.to_s.reverse.downcase
        DataWrangler::Validators::Result.failure(value, [string])
      end
    end

    # Returns a valid result
    class TrueValidator < DataWrangler::Validators::Field::Base
      def validate(value = nil)
        string = value.to_s.reverse.downcase
        DataWrangler::Validators::Result.success(value, string)
      end
    end

    # Splits the value into an array
    class TrueToArrayValidator < DataWrangler::Validators::Field::Base
      def validate(value)
        new_value = value.split(";")
        DataWrangler::Validators::Result.success(value, new_value)
      end
    end

    class FieldValidatorTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_instantiation
        subject = DataWrangler::Validators::Field::Base.new
        refute subject.nil?
      end

      def test_returns_result
        subject = DataWrangler::Validators::Field::Base.new
        result = subject.run("test")
        assert_equal "test", result.sanitized
        assert result.valid?
      end

      # Our first validator returns a false result, so
      # subsequent validations should be false
      def test_handles_chained_result
        prev_result = FalseValidator.new.run("Bad")
        subject = DataWrangler::Validators::Field::Base.new.run(prev_result)
        refute subject.valid?
      end

      # Handles multiple errors
      def test_multiple_error_results
        prev_result = FalseValidator.new.run("Bad")

        # Sanitized will be 'dab'
        curr_result = FalseValidator.new.run(prev_result)

        # Sanitized will be 'bad'
        subject = DataWrangler::Validators::Field::Base.new.run(curr_result)
        refute subject.valid?
        assert_equal(%w[dab dab], subject.errors)
        assert_equal "Bad", subject.original_value
      end

      # Handles multiple successes
      def test_chained_successes_with_single_value
        prev_result = TrueValidator.new.run("Good")

        # Sanitized will be 'doog'
        curr_result = TrueValidator.new.run(prev_result)

        # Sanitized will be 'good'
        subject = DataWrangler::Validators::Field::Base.new.run(curr_result)
        assert subject.valid?
        assert subject.errors.empty?
        assert_equal "Good", subject.original_value
        assert_equal "good", subject.sanitized
      end

      # Handles multiple successes
      def test_chained_successes_with_single_to_multiple_values
        # Sanitized will be 'doog;yrev'
        prev_result = TrueValidator.new.run("Very;Good")

        # Sanitized will be ['doog', 'yrev']
        curr_result = TrueToArrayValidator.new.run(prev_result)

        # Sanitized will be 'good'
        subject = DataWrangler::Validators::Field::Base.new.run(curr_result)
        assert subject.valid?
        assert subject.errors.empty?
        assert_equal "Very;Good", subject.original_value
        assert_equal %w[doog yrev], subject.sanitized
      end

      def test_mixed_validation_results
        prev_result = FalseValidator.new.run("Good")
        curr_result = TrueValidator.new.run(prev_result)

        # Sanitized will be 'good'
        subject = DataWrangler::Validators::Field::Base.new.run(curr_result)
        refute subject.valid?
        refute subject.errors.empty?
        assert_equal "Good", subject.original_value
        assert_nil subject.sanitized
      end
    end
  end
end
