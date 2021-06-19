# frozen_string_literal: true

require_relative "../../test_helper"

module DataWrangler
  module Book
    class CellTest < Minitest::Test
      def setup
      end

      def test_accepts_nil
        subject = _new_cell(nil)
        assert subject.value.nil?
      end

      def test_accepts_string
        subject = _new_cell("Data wrangler")
        refute subject.empty?
        assert_equal "Data wrangler", subject.value
      end

      def test_accepts_cell
        subject = _new_cell(_new_cell("Fugazi"))
        assert_equal "Fugazi", subject.value
      end

      def test_simple_processor_chain
        processors = [
          DataWrangler::Validators::Field::CharacterLength.new(
            {"min" => 2, "max" => 6, "trim" => true}
          ),
          DataWrangler::Validators::Field::CharacterLength.new(
            {"min" => 2, "max" => 4, "trim" => true}
          )
        ]
        subject = _new_cell("longer than it should be")
        subject._process(processors)
        assert_equal "long", subject.sanitized
      end

      def test_extended_processor_chain
        # split token, downcase elements and limit list to max 4 terms
        processors = [
          DataWrangler::Transformers::Field::SplitString.new(
            {"separator" => ",;|"}
          ),
          DataWrangler::Transformers::Field::Downcase.new,
          DataWrangler::Validators::Field::TokenList.new(
            {"min" => 2, "max" => 4, "trim" => true}
          )
        ]
        subject = _new_cell("mars, Mercury|| Uranus; Earth; Pluto")
        subject._process(processors)
        assert_equal(%w[mars mercury uranus earth], subject.sanitized)
      end

      def test_extended_processor_chain_short_circuited_by_error
        # split token, downcase elements and limit list to max 4 terms
        processors = [
          DataWrangler::Transformers::Field::SplitString.new(
            {"separator" => ",;|"}
          ),
          DataWrangler::Validators::Field::TokenList.new(
            {"max" => 2}
          ),
          DataWrangler::Transformers::Field::Downcase.new
        ]
        subject = _new_cell("mars, Mercury|| Uranus; Earth; Pluto")
        subject._process(processors)
        refute subject.valid?
        assert_equal(["token count must be between 0 and 2 (5 received)"], subject.errors)
      end

      def _new_cell(thing)
        DataWrangler::Book::Cell.new(thing)
      end
    end
  end
end
