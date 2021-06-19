# frozen_string_literal: true

require_relative "../test_helper"

module DataWrangler
  class ReadersTest < Minitest::Test
    def setup
    end

    def factory_method
      assert_raises StandardError do
        DataWrangler::Readers.for("something.pdf")
      end
    end

    def test_factory_method
      {
        "something.xlsx" => DataWrangler::Readers::XlsxReader,
        "something.xls" => DataWrangler::Readers::XlsReader,
        "something.txt" => DataWrangler::Readers::TxtReader,
        "something.csv" => DataWrangler::Readers::CsvReader
      }.each_pair do |filename, klass|
        subject = DataWrangler::Readers.for(filename)
        assert subject.is_a?(klass), "#{filename} should instantiate as #{klass}"
      end
    end
  end
end
