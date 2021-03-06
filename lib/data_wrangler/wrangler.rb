# frozen_string_literal: true

module DataWrangler
  # Main class
  class Wrangler
    attr_reader :book, :configuration

    def initialize(filepath, configpath:, key: nil, options: nil)
      @filepath = filepath
      @configuration = _instantiate_configuration(configpath, key)
      @book = DataWrangler::Book::Base.new(@filepath, options)
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
