# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Validators
    module Field
      # Custom subclass
      class DowncaseTokenList < DataWrangler::Validators::Field::TokenList
        def validate(list)
          super(list.map { |v| v.to_s.downcase }.uniq)
        end
      end

      class TokenListTest < Minitest::Test
        def setup
        end

        def teardown
        end

        def test_validation
          subject = _new_validator({"min" => 1, "max" => 3})
          result = subject.run(%w[Venus Mars Jupiter])
          assert result.valid?
          assert_equal(%w[Venus Mars Jupiter], result.sanitized)
        end

        def test_trimmed_list
          subject = _new_validator({"min" => 1, "max" => 3, "trim" => true})
          result = subject.run(%w[Venus Mars Jupiter Pluto])
          assert result.valid?
          assert_equal(%w[Venus Mars Jupiter], result.sanitized)
        end

        def test_dedupe
          subject = _new_validator({"min" => 1, "max" => 5})
          result = subject.run(%w[Venus Mars Mars Jupiter])
          assert result.valid?
          assert_equal(%w[Venus Mars Mars Jupiter], result.sanitized)
        end

        # Subclasses
        def test_subclass
          subject = DowncaseTokenList.new
          result = subject.run(%w[veNUS Venus Mars Jupiter])
          assert result.valid?
          assert_equal(%w[venus mars jupiter], result.sanitized)
        end

        def _new_validator(options)
          DataWrangler::Validators::Field::TokenList.new(options)
        end
      end
    end
  end
end
