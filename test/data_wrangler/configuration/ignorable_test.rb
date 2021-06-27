# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Configuration
    class Testable
      include Ignorable

      def initialize(options)
        _load_ignore_record_config(options)
      end
    end

    class IgnorableTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_ignore_column?
        config = default_config.merge({
          "ignore_columns" => {
            "numbers" => [1, 2],
            "containing" => ["Ignore 1"]
          }
        })

        subject = Testable.new(config)
        assert(subject.ignore_column?(1, ["Something 1", "Something 2"]))
        assert(subject.ignore_column?(3, ["Ignore 1", "Something 2"]))
      end

      def test_ignore_row?
        config = default_config.merge({
          "ignore_rows" => {
            "numbers" => [1, 2],
            "containing" => ["Help: Info"]
          }
        })

        subject = Testable.new(config)
        assert(subject.ignore_row?(1, ["Something 1", "Something 2"]))
        assert(subject.ignore_row?(3, ["Help: Info", "", nil]))
      end

      private

      def default_config
        {
          "ignore_rows" => {
            "numbers" => []
          },
          "ignore_columns" => {
            "containing" => []
          }
        }
      end
    end
  end
end
