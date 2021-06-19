# frozen_string_literal: true

require_relative "../../../test_helper"
require_relative "cases/linked_fields"

module DataWrangler
  module Validators
    module Record
      class BaseTest < Minitest::Test
        def setup
        end

        def test_initialize_without_config
          validator = record_base
          assert_equal "DataWrangler::Validators::Record::Base", validator.namespace
          assert validator.run.success?
        end

        def test_subclass_succeeds
          record = DataWrangler::Book::Record.new(
            [["OK", nil], 0]
          )

          validator = DataWrangler::Validators::Record::Cases::LinkedFields.new
          assert validator.run(record).success?
        end

        def test_subclass_fails
          record = DataWrangler::Book::Record.new(
            [["OK", "Not OK"], 0]
          )

          validator = DataWrangler::Validators::Record::Cases::LinkedFields.new
          refute validator.run(record).valid?
        end

        def record_base(config = {})
          DataWrangler::Validators::Record::Base.new(config)
        end
      end
    end
  end
end
