# frozen_string_literal: true

module DataWrangler
  module Validators
    # Abstract Result class
    class Result
      attr_reader :original_value
      attr_accessor :errors

      class << self
        def success(original_value, sanitized = nil)
          new(original_value, sanitized: sanitized)
        end

        def failure(original_value, errors)
          new(original_value, errors: errors)
        end
      end

      def initialize(original_value, sanitized: nil, errors: [])
        @original_value = original_value
        @sanitized = sanitized
        @errors = Array(errors).flatten
      end

      def chainable_value
        sanitized || @original_value
      end

      def error_string
        @errors.join("; ")
      end

      def sanitized
        return nil if @errors.any?

        @sanitized.nil? ? @original_value : @sanitized
      end

      def valid?
        @errors.none?
      end
      alias_method :success?, :valid?

      def failure?
        !valid?
      end
    end
  end
end
