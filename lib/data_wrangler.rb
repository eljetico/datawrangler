# frozen_string_literal: true

require "open3"
require "securerandom"
require "shellwords"
require "date"
require "json"
require_relative "core_extensions"

# Convenient read-sanitize-validate handler for tabulated data files
module DataWrangler
  class Error < StandardError; end
end

require_relative "data_wrangler/book"

require_relative "data_wrangler/field_processor"
require_relative "data_wrangler/transformers"
require_relative "data_wrangler/conformers"
require_relative "data_wrangler/validators"
require_relative "data_wrangler/configuration"
require_relative "data_wrangler/formatter"
require_relative "data_wrangler/header"
require_relative "data_wrangler/wrangler"
