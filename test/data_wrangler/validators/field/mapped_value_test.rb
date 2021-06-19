# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      class MappedValueTest < Minitest::Test
        def setup
          @map = {
            "A" => "US Domestic News",
            "E" => "Entertainment",
            "I" => "Non-US Domestic News",
            "S" => "Sports"
          }

          @synonymized_map = {
            "A" => ["US Domestic News", "Domestic News"],
            "E" => ["Entertainment", "Arts & Entertainment"],
            "I" => ["Non-US Domestic News", "Non US Domestic News"],
            "S" => %w[Sports Sport]
          }
        end

        def teardown
        end

        def test_blank_value
          subject = _new_validator(
            {
              "map" => @map
            }
          )
          result = subject.run(nil)
          refute result.valid?
          assert_equal "must be a valid value ('' received)", result.error_string
        end

        def test_default_validation_using_value
          subject = _new_validator(
            {
              "map" => @map,
              "case_sensitive" => true
            }
          )
          result = subject.run("US Domestic News")
          assert result.valid?
          assert_equal "A", result.sanitized
        end

        def test_default_validation_extracting_value
          subject = _new_validator(
            {
              "map" => @map,
              "lookup" => "value"
            }
          )
          result = subject.run("us DoMestIc news")
          assert result.valid?
          assert_equal "US Domestic News", result.sanitized
        end

        def test_validation
          subject = _new_validator(
            {
              "map" => @map
            }
          )
          result = subject.run("A")
          assert result.valid?
          assert_equal "A", result.sanitized
        end

        def test_synonymised_map_case_insensitive
          subject = _new_validator(
            {
              "map" => @synonymized_map
            }
          )
          result = subject.run("sport")
          assert result.valid?
          assert_equal "S", result.sanitized
        end

        def test_synonymised_map_case_sensitive
          subject = _new_validator(
            {
              "map" => @synonymized_map,
              "case_sensitive" => true
            }
          )
          result = subject.run("NON US Domestic News")
          refute result.valid?
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::MappedValue.new(options)
        end
      end
    end
  end
end
