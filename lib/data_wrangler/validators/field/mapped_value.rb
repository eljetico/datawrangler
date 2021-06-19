# frozen_string_literal: true

module DataWrangler
  module Validators
    module Field
      # Looks up values from a key/value store, valid if value matches
      # either key or value, optionally case-insensitive and returns
      # either matching key or value (configurable, default = key)
      #
      # Note, recommended to keep the map fairly small
      class MappedValue < DataWrangler::Validators::Field::Base
        def initialize(config = nil)
          config = {
            "map" => {},
            "case_sensitive" => false
          }.deep_merge(config || {})

          super(config)

          # Lookup either 'key' or 'value' from the configured map, default to key
          @lookup = @config.fetch("lookup", "key").to_sym
          @case_sensitive = @config.fetch("case_sensitive", false)

          _normalize_map_for_case_sensitivity
        end

        def validate(value)
          clean_value = _extract_value(value)
          if blank?(clean_value)
            DataWrangler::Validators::Result.failure(value, error_message(value))
          else
            DataWrangler::Validators::Result.success(value, clean_value)
          end
        end

        def error_message(value)
          @config["error_message"] || "must be a valid value ('#{value}' received)"
        end

        def _extract_value(value)
          return nil if blank?(value)

          key = _searchable_token(value)
          result = @map.fetch(key) { {key: nil, value: nil} }
          result[@lookup]
        end

        # Remaps the configured map to allow for (possibly) case insensitive searches
        # We need to retain a reference to original key, values as these are the
        # results we need to return regardless of search.
        #
        # Each value of the original 'map' can be a string or array of synonyms: they
        # are all coerced into new keys pointing to the orig {key:, value:} pairs.
        #
        # There may be conflicts between keys and values, although hopefully these
        # are never introduced.
        #
        # Maps should be kept fairly small, although the `values` variable constructed
        # here will be the same in memory
        def _normalize_map_for_case_sensitivity
          @map = {}
          @config["map"].each_pair do |k, v|
            new_keys = [k, Array(v)].flatten.compact.map do |nk|
              _searchable_token(nk)
            end

            values = {
              key: k,
              value: v
            }

            # Add both hashed k and v to the new map
            new_keys.uniq.each do |mk|
              @map[mk] = values
            end
          end
        end

        def _searchable_token(token)
          (@case_sensitive ? token.to_s : token.to_s.downcase).hash
        end
      end
    end
  end
end
