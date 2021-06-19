# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      class DateRangeTest < Minitest::Test
        def setup
          @invalid_date_string = "2001-02-29"
        end

        def teardown
        end

        def test_configures_with_strings
          subject = _new_validator(
            {
              "from" => "1970-03-14",
              "to" => Date.today.to_s
            }
          )
          result = subject.run(Date.today)
          assert result.valid?
        end

        # 2001-02-29 fails as an invalid date
        def test_raises_error_with_invalid_dates
          assert_raises DataWrangler::Configuration::Error do
            _new_validator(
              {
                "from" => @invalid_date_string,
                "to" => Date.today.to_s
              }
            )
          end
        end

        def test_validation
          subject = _new_validator({"from" => Date.new(1970, 3, 14)})
          result = subject.run(Date.today)
          assert result.valid?
        end

        def test_out_of_range
          subject = _new_validator({"from" => Date.new(1970, 3, 14)})
          result = subject.run(Date.new(1900, 1, 1))
          refute result.valid?
          assert_match(/date must be between .*? \('1900-01-01' received\)/, result.error_string)
        end

        def test_with_string_value
          subject = _new_validator({"from" => Date.new(1970, 3, 14)})
          result = subject.run("2000-03-14")
          assert result.valid?
          assert result.sanitized.respond_to?(:to_date)
        end

        def test_with_invalid_date_value
          subject = _new_validator({"from" => Date.new(1970, 3, 14)})
          result = subject.run(@invalid_date_string)
          refute result.valid?
          assert_equal "invalid date ('2001-02-29' received)", result.error_string
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::DateRange.new(options)
        end
      end
    end
  end
end
