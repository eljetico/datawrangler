# frozen_string_literal: true

require_relative "base"

module DataWrangler
  module Conformers
    module Field
      # Map the supplied value from a dictionary of one or more possible
      # synonym-like options, optionally case-sensitive
      class MappedValue < DataWrangler::Conformers::Field::Base
        attr_reader :separator

        def initialize(config = nil)
          super(config)

          # Lookup either 'key' or 'value' from the configured map,
          # defaults to return the 'key' of the map for a given value
          # If 'strict' is configured, map misses will return a failure
          # Result.
          @lookup = @config.fetch("lookup", "key").to_sym
          @case_sensitive = @config.fetch("case_sensitive", false)
          @strict = @config.fetch("strict", false)

          # Prepare our map
          _normalize_map_for_case_sensitivity
        end

        def conform(value = nil)
          clean_value = _extract_value(value)

          if blank?(clean_value)
            return _failure(value, "Cannot map value '#{value}'") if @strict

            clean_value = nil
          end

          _success(value, clean_value)
        end

        def _extract_value(value)
          return nil if blank?(value)

          key = _searchable_token(value)
          result = @map.fetch(key) { {key: nil, value: nil} }
          result[@lookup]
        end

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
