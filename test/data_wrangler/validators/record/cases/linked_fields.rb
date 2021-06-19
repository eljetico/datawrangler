# frozen_string_literal: true

module DataWrangler
  module Validators
    module Record
      module Cases
        class LinkedFields < DataWrangler::Validators::Record::Base
          def initialize
            config = {
              "namespace" => "LinkedFields"
            }
            super(config)
          end

          def blank?(value)
            value.to_s.eql?("")
          end

          # Keeping this simple with unconfigured record/cell combo
          # In this case we'll just check cell values against each
          # other
          def validate(record)
            # If Cell 0 is empty, then Cell 1 should not be
            # and vice versa
            if record.cells[0].empty?
              record.cells[1].empty? ? failure("Cell 1 should not be blank") : success
            else
              # Not empty
              record.cells[1].empty? ? success : failure("Cell 1 should be blank")
            end
          end

          def failure(msg)
            DataWrangler::Validators::Result.failure(namespace, msg)
          end

          def success
            DataWrangler::Validators::Result.success(namespace)
          end
        end
      end
    end
  end
end
