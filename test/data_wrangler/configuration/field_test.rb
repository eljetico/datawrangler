# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  class CustomFalseValidator < DataWrangler::Validators::Field::Base
    def process(value)
      DataWrangler::Validators::Result.new(value, false)
    end
  end

  class CustomHeader < DataWrangler::Header
    def to_s
      super.reverse
    end
  end

  module Configuration
    class FieldTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_default_config
        subject = new_field("File Name")
        assert_equal "File Name", subject.header.to_s
      end

      def test_custom_header
        config = {
          "header" => "DataWrangler::CustomHeader"
        }
        subject = new_field("Test Header", config)
        assert_equal "redaeH tseT", subject.header.to_s
      end

      def test_default_validator_instantiation
        subject = new_field("File Name")
        assert_equal "File Name", subject.header.to_s
        assert subject.processors.empty?
      end

      def test_raises_error_on_bad_validator
        assert_raises DataWrangler::Configuration::Error do
          config = {
            "validators" => [
              {
                "validator" => "DataWrangler::Validators::TestValidator"
              }
            ]
          }
          new_field("File Name", config)
        end
      end

      def test_custom_validator
        config = {
          "validators" => [
            {
              "validator" => "DataWrangler::CustomFalseValidator"
            }
          ]
        }
        subject = new_field("File Name", config)
        refute subject.validators.empty?
        assert subject.validators[0].is_a?(DataWrangler::CustomFalseValidator)
      end

      def test_namespaced_validator
        config = {
          "validators" => [
            {
              "validator" => "CharacterLength"
            }
          ]
        }
        subject = new_field("File Name", config)
        refute subject.validators.empty?
        assert subject.validators[0].is_a?(DataWrangler::Validators::Field::CharacterLength)
      end

      # Transformers
      def test_namespaced_transformer
        config = {
          "processors" => [
            {
              "transformer" => "SplitString"
            }
          ]
        }
        subject = new_field("Keywords", config)
        refute subject.processors.empty?
        assert subject.processors[0].is_a?(DataWrangler::Transformers::Field::SplitString)
      end

      def test_raises_error_on_bad_transformer
        assert_raises DataWrangler::Configuration::Error do
          config = {
            "processors" => [
              {
                "transformer" => "DataWrangler::Transformers::Field::Test"
              }
            ]
          }
          new_field("File Name", config)
        end
      end

      # Headers
      def test_valid_headers
        subject = new_field("Field Name", {"aliases" => ["Alias 1", "alias 2"]})

        assert_equal 2, subject.aliases.length
        assert subject.valid_headers.include?("Alias 1")
        assert subject.valid_headers.include?("field name")
        assert subject.valid_headers.include?("Field Name")
      end

      private

      def new_field(f_name, f_config = nil)
        DataWrangler::Configuration::Field.new(f_name, f_config)
      end
    end
  end
end
