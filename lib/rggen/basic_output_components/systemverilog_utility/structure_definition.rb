# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class StructureDefinition <
        Core::Utility::CodeUtility::StructureDefinition

        include Core::Utility::AttributeSetter

        def initialize(**default_attributes, &block)
          apply_attributes(default_attributes)
          super(&block)
        end

        private

        def process_declarations_in_header(declarations, code)
          declarations.empty? || indent(code, 2) do
            declarations.each_with_index do |declaration, i|
              code << comma << nl if i.positive?
              code << declaration
            end
          end
        end

        def process_declarations_in_body(declarations, code)
          declarations.each { |d| code << d << semicolon << nl }
        end
      end
    end
  end
end
