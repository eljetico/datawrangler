# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Validators
    class SheetValidatorTest < Minitest::Test
      def setup
      end

      def teardown
      end

      def test_basic
        assert true
      end

      private

      def new_config(name, s_config = nil)
        DataWrangler::Configuration::Sheet.new(name, s_config)
      end
    end
  end
end
