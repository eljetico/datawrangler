# frozen_string_literal: true

require "yaml"
require_relative "../test_helper"

module DataWrangler
  class WranglerTest < Minitest::Test
    def setup
    end

    def teardown
    end

    def test_editorial_stills
      filepath = xlsx_path("one_sheet_columnar.xlsx")
      config = configuration_path("editorial_stills.yml")
      wrangler = DataWrangler::Wrangler.new(filepath, configpath: config, key: "editorial_stills_default")
      assert 1, wrangler.book.sheets.length
      # assert wrangler.validate
    end
  end
end
