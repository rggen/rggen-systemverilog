# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class FunctionDefinition < StructureDefinition
          define_attribute :name
          define_attribute :return_type
          define_attribute :arguments

          def return_type(**attributes)
            attributes.size.zero? || (
              @return_type = DataObject.new(:variable, **attributes)
            )
            @return_type
          end

          private

          def header_code(code)
            code << :function
            return_type_declaration(code)
            code << [space, name]
            argument_declarations(code)
            code << semicolon
          end

          def return_type_declaration(code)
            return unless @return_type
            code << [space, return_type.declaration]
          end

          def argument_declarations(code)
            wrap(code, '(', ')') do
              add_declarations_to_header(code, Array(arguments))
            end
          end

          def footer_code
            :endfunction
          end
        end
      end
    end
  end
end
