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
            attributes.empty? ||
              (@return_type = DataObject.new(:variable, **attributes))
            @return_type
          end

          private

          def header_code(code)
            function_header_begin(code)
            return_type_declaration(code)
            function_name(code)
            argument_declarations(code)
            function_header_end(code)
          end

          def function_header_begin(code)
            code << 'function'
          end

          def return_type_declaration(code)
            return unless @return_type
            code << [space, return_type.declaration]
          end

          def function_name(code)
            code << space << name
          end

          def argument_declarations(code)
            wrap(code, '(', ')') do
              add_declarations_to_header(code, Array(arguments))
            end
          end

          def function_header_end(code)
            code << semicolon
          end

          def footer_code
            'endfunction'
          end
        end
      end
    end
  end
end
