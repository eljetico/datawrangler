# frozen_string_literal: true

require_relative "validators/result"

module DataWrangler
  # Memoized, chainable field processor parent class for Validation
  # and Transformer instances.
  # Subclasses should implement a 'process_value' method to return
  # an instance of DataWrangler::Validators::Result
  class FieldProcessor
    def initialize(config = {})
      @config = config
      @cache = {}
    end

    def blank?(value = nil)
      value.to_s.eql?("")
    end

    def clean_token(token)
      token.to_s.gsub(/\A"|"\Z/, "").strip
    end

    def parse_list_values(value, delimiters = ";,|")
      return [] if value.nil?

      return value if value.is_a?(Array)

      value.to_s.scan(/\s*([^#{delimiters}]+)\s*/)
        .flatten
        .reject { |r| blank?(r) }
        .map { |s| clean_token(s) }
    end

    def run(value = nil)
      if value.is_a?(DataWrangler::Validators::Result)
        result = _cached_result(value.chainable_value)
        return _combined_results(value, result)
      end

      _cached_result(value)
    end

    private

    def _cached_result(value = nil)
      # value = _possibly_default(value) # Now handled in Transformers
      cache_key = _formatted_key(value)
      response = @cache[cache_key]

      if response.nil?
        response = process_value(value)
        @cache[cache_key] = response
      end

      response
    end

    def _combined_results(prev_result, result)
      original_value = prev_result.original_value
      errors = [prev_result.errors, result.errors].flatten

      if errors.any?
        DataWrangler::Validators::Result.failure(original_value, errors)
      else
        DataWrangler::Validators::Result.success(original_value, result.sanitized)
      end
    end

    # Some validators may need to override?
    def _formatted_key(value = nil)
      value.to_s.hash
    end

    def _success(value, sanitized = nil)
      DataWrangler::Validators::Result.success(value, sanitized)
    end

    def _failure(value, errors)
      DataWrangler::Validators::Result.failure(value, errors)
    end
  end
end
