# frozen_string_literal: true

require_relative "readers/decoded_text"
require_relative "readers/general_reader"
require_relative "readers/xls_reader"
require_relative "readers/xlsx_reader"
require_relative "readers/txt_reader"
require_relative "readers/csv_reader"

module DataWrangler
  # Main readers module
  module Readers
    def self.for(filepath)
      extension = File.extname(filepath).downcase

      readers = {
        ".xls" => "XlsReader",
        ".xlsx" => "XlsxReader",
        ".txt" => "TxtReader",
        ".csv" => "CsvReader"
      }.freeze

      reader = readers[extension]
      Object.const_get("DataWrangler::Readers::#{reader}").new
    end
  end
end
