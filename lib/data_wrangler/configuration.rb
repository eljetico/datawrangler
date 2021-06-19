# frozen_string_literal: true

require_relative "validators"
require_relative "configuration/book"

module DataWrangler
  # Handle template configuration
  module Configuration
    class Error < StandardError; end
  end
end
