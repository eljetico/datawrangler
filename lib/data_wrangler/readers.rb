# frozen_string_literal: true

require_relative "readers/decoded_text"
require_relative "readers/dummy_reader"
require_relative "readers/general_reader"
require_relative "readers/xls_reader"
require_relative "readers/xlsx_reader"
require_relative "readers/txt_reader"
require_relative "readers/csv_reader"

module DataWrangler
  # Main readers module
  module Readers
    def self.for(filepath, options = nil)
      options ||= {}
      options.fetch(:reader, _for(filepath))
    end

    def self._for(filepath)
      reader = {
        ".xls" => "XlsReader",
        ".xlsx" => "XlsxReader",
        ".txt" => "TxtReader",
        ".csv" => "CsvReader"
      }.freeze[File.extname(filepath).downcase]

      Object.const_get("DataWrangler::Readers::#{reader}").new
    end
  end
end
