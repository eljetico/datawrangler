# frozen_string_literal: true

module DataWrangler
  module Readers
    class DummyReader
      attr_accessor :data

      def initialize
        @data = []
      end

      def parse(_filepath)
      end
    end
  end
end
