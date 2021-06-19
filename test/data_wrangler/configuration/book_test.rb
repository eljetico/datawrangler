# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Configuration
    class BookTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_accepts_book_hash
        subject = _new_book_configuration({"ignore_sheet_names" => ["Sheet 2"]})
        assert subject.ignore_sheet?("Sheet 2")
        refute subject.ignore_sheet?("Sheet 1")
      end

      # Simulate config read in from combined yaml file, eg
      def test_accepts_optional_search_key
        config = {
          "editorial" => {
            "ignore_sheet_names" => ["Sheet 2"]
          },
          "creative" => {
            "ignore_sheet_names" => ["Sheet 4"]
          }
        }
        subject = _new_book_configuration(config, key: "creative")
        assert subject.ignore_sheet?("Sheet 4")
        refute subject.ignore_sheet?("Sheet 1")
      end

      def test_accepts_filename
        filepath = configuration_path("editorial_stills.yml")
        subject = _new_book_configuration(filepath, key: "editorial_stills_default")
        assert_equal 1, subject.sheet_configurations.count
        assert subject.sheet_configurations[0].required_fields.include?("file name")
      end

      def test_default_config
        subject = _new_book_configuration
        assert_equal 1, subject.sheet_configurations.count
        assert subject.sheet_configurations[0].is_a?(DataWrangler::Configuration::Sheet)
      end

      private

      def _new_book_configuration(*args)
        DataWrangler::Configuration::Book.new(*args)
      end
    end
  end
end
