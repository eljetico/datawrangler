# frozen_string_literal: true

require_relative "conformers/field"

module DataWrangler
  # Collection of field conformers, similar but different from Validators in that
  # they respond to the question: 'will you conform to x requirements?'. If
  # the supplied value conforms, a (possibly) conformed value is returned
  # in a Result.success instance, if not, a Result.failure instance.
  # Can be surrounded by additional processors such as Transformers, Validators
  module Conformers
  end
end
