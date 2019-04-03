# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Utility
      class ModuleDefinition < StructureDefinition
        define_attribute :name
        define_attribute :packages
        define_attribute :parameters
        define_attribute :ports
        define_attribute :variables

        private

        def header_code(code)
          code << :module << space << name
          package_import_declaration(code)
          parameter_declarations(code)
          port_declarations(code)
          code << semicolon
        end

        def package_import_declaration(code)
          if (imports = pacakge_imports).empty?
            code << space
            return
          end
          indent(code, 2) do
            code << imports.join(",\n") << semicolon
          end
        end

        def pacakge_imports
          Array(packages).map.with_index do |package, i|
            if i.zero?
              [:import, "#{package}::*"].join(space)
            else
              [space(6), "#{package}::*"].join(space)
            end
          end
        end

        def parameter_declarations(code)
          declarations = Array(parameters)
          declarations.empty? || wrap(code, '#(', ')') do
            process_declarations_in_header(Array(parameters), code)
          end
        end

        def port_declarations(code)
          declarations = Array(ports)
          wrap(code, '(', ')') do
            process_declarations_in_header(declarations, code)
          end
        end

        def pre_body_code(code)
          process_declarations_in_body(Array(variables), code)
        end

        def footer_code
          :endmodule
        end
      end
    end
  end
end
