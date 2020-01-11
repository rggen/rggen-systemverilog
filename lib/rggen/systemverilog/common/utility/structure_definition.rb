# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class StructureDefinition <
          Core::Utility::CodeUtility::StructureDefinition

          include Core::Utility::AttributeSetter

          def initialize(default_attributes = {}, &block)
            apply_attributes(**default_attributes)
            super(&block)
          end

          private

          def add_declarations_to_header(code, declarations, terminator = '')
            declarations.empty? || indent(code, 2) do
              declarations.each_with_index do |d, i|
                code <<
                  if i < (declarations.size - 1)
                    [d, comma, nl]
                  else
                    [d, terminator]
                  end
              end
            end
          end

          def add_declarations_to_body(code, declarations, terminator = ';')
            declarations.each { |d| code << d << terminator << nl }
          end
        end
      end
    end
  end
end
