# frozen_string_literal: true

require_relative "../result"

module DataWrangler
  module Validators
    module Sheet
      # Subclass this validator for more specific Sheet-wide checks
      class Base
        attr_reader :errors

        # Passing the 'deferred' option will force this validator to be run
        # after Records are loaded and validated
        def initialize(config = {})
          @config = {
          }.deep_merge(config)

          @errors = []
        end

        # Postpone this validator until after processing of records
        def deferred?
          @deferred ||= @config.fetch("deferred", true)
        end

        # Accepts a DataWrangler::Book::Sheet instance
        def run(sheet)
          validate(sheet)
        end

        def namespace
          @config.fetch("namespace", self.class.name)
        end

        def _result(errors = [])
          if errors.any?
            DataWrangler::Validators::Result.failure(namespace, errors)
          else
            DataWrangler::Validators::Result.success(namespace, errors)
          end
        end

        def validate(*)
          _result
        end

        def valid?
          @errors.empty?
        end
      end
    end
  end
end
