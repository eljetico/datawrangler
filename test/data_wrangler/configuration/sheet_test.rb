# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Configuration
    class SheetTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_default_config
        subject = new_sheet("assets")
        assert_equal "assets", subject.namespace
        assert_equal "row", subject.parse_by
        refute subject.parse_by_column?
      end

      def test_required_header_map
        config = load_configuration(
          filename: "image_metadata.yml",
          key: "image_metadata"
        )["sheets"]["images"]

        subject = new_sheet("image", config)
        result = subject.required_header_map

        assert result.key?("file name")
        refute result.key?("caption")
      end

      def test_editorial_stills_config
        config = load_configuration(
          filename: "editorial_stills.yml",
          key: "editorial_stills_default"
        )["sheets"]["assets"]

        subject = new_sheet("assets", config)
        refute subject.nil?

        assert subject.required_field_aliases.include?("file name")
        field_config = subject.config_for_header("file name")
        assert field_config.validators[0].is_a?(
          DataWrangler::Validators::Field::CharacterLength
        )
      end

      def test_creative_stills_config
        config = load_configuration(
          filename: "creative_stills.yml",
          key: "ipw_standard"
        )["sheets"]["assets"]

        subject = new_sheet("assets", config)
        refute subject.nil?

        assert subject.required_field_aliases.include?("Original Filename")
        refute subject.required_field_aliases.include?("Release Name")
      end

      def test_creative_video_config
        config = load_configuration(
          filename: "creative_video.yml",
          key: "nyc_market_log"
        )["sheets"]["general_information"]

        subject = new_sheet("general_information", config)
        refute subject.nil?

        assert subject.required_field_aliases.include?(" Production Company:")
      end

      private

      def new_sheet(name, s_config = nil)
        DataWrangler::Configuration::Sheet.new(name, s_config)
      end
    end
  end
end
