# frozen_string_literal: true

module DataWrangler
  # Base Header class for application to Cell/Field instances during formatting
  # Subclassable as required, and can be configured via templates
  #
  class Header
    attr_writer :actual
    OPTS = {}.freeze

    def initialize(field_name, config = OPTS)
      @config = config
      @field_name = field_name
      @actual = nil
    end

    def aliases
      @aliases ||= @config.fetch("aliases", [])
    end

    def to_s
      @actual || @field_name
    end

    def sanitized
      to_s.downcase
    end
  end
end
