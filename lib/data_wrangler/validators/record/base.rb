# frozen_string_literal: true

require_relative "../result"

module DataWrangler
  module Validators
    module Record
      # TODO: improve docs after implementation
      # The foundational DataWrangler::Book::Record validator configured
      # via templates.
      # Subclasses should implement 'validate' method
      # and supply 'namespace' in template config.
      # Note that linked fields should reference each field using
      # sanitized field names, eg dereferenced aliases
      class Base
        attr_reader :errors

        def initialize(config = {})
          @config = {
          }.deep_merge(config)
          @errors = []
        end

        # Returns a DataWrangler::Validators::Result instance
        def run(record = nil)
          validate(record)
        end

        def namespace
          @config.fetch("namespace", self.class.name)
        end

        # Override this method
        def validate(_record)
          DataWrangler::Validators::Result.success(namespace)
        end

        def valid?
          @errors.empty?
        end
      end
    end
  end
end
