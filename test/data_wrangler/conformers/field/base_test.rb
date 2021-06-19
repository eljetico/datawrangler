# frozen_string_literal: true

require_relative "../../../test_helper"

module DataWrangler
  module Conformers
    module Field
      class BaseTest < Minitest::Test
        def setup
        end

        def test_chained_conformers
          assert true
        end

        # def _split_string_transformer(config = {})
        #   DataWrangler::Transformers::Field::SplitString.new(config)
        # end
      end
    end
  end
end
