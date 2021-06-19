# frozen_string_literal: true

require_relative "validators/result"

require_relative "validators/field"
require_relative "validators/record"
require_relative "validators/sheet"

require_relative "validators/field_validator"
require_relative "validators/record_validator"
require_relative "validators/sheet_validator"

module DataWrangler
  # Handle configured validators
  module Validators
  end
end
