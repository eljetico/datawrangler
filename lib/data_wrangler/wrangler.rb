# frozen_string_literal: true

module DataWrangler
  # Main class
  class Wrangler
    attr_reader :book, :configuration, :formatter

    def initialize(filepath, configpath:, key: nil)
      @filepath = filepath
      @configuration = _instantiate_configuration(configpath, key)
      @book = DataWrangler::Book::Base.new(@filepath)
      DataWrangler::Formatter::Base.new(@book, @configuration).configure
    end

    def validate
      @book.validate
    end

    private

    def _instantiate_configuration(configpath, key = nil)
      DataWrangler::Configuration::Book.new(configpath, key: key)
    end
  end
end
