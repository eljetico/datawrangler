# frozen_string_literal: true

require "charlock_holmes"

module DataWrangler
  module Readers
    # Abstract class to handle various encodings
    class DecodedText
      attr_reader :encoding, :contents

      def initialize(file_path)
        @encoding = "unknown"
        @contents = nil

        @contents = File.read(file_path)
        detection = CharlockHolmes::EncodingDetector.detect(contents)
        @encoding = detection.fetch(:encoding, "unknown")
      end
    end
  end
end
