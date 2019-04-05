# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Utility
      class ModuleDefinition < StructureDefinition
        define_attribute :name
        define_attribute :package_imports
        define_attribute :parameters
        define_attribute :ports
        define_attribute :variables

        def package_imports(packages)
          @package_imports ||= []
          @package_imports.concat(Array(packages))
        end

        def package_import(package)
          package_imports([package])
        end

        private

        def header_code(code)
          code << [:module, space, name]
          package_import_declaration(code)
          parameter_declarations(code)
          port_declarations(code)
          code << semicolon
        end

        def package_import_declaration(code)
          if (items = pacakge_import_items).empty?
            code << space
            return
          end
          add_declarations_in_header(code, items, semicolon)
        end

        def pacakge_import_items
          Array(@package_imports).map.with_index do |package, i|
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
            add_declarations_in_header(code, declarations)
          end
        end

        def port_declarations(code)
          declarations = Array(ports)
          wrap(code, '(', ')') do
            add_declarations_in_header(code, declarations)
          end
        end

        def pre_body_code(code)
          add_declarations_in_body(code, Array(variables))
        end

        def footer_code
          :endmodule
        end
      end
    end
  end
end
