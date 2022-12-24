# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class PackageDefinition < StructureDefinition
          define_attribute :name
          define_attribute :package_imports
          define_attribute :include_files
          define_attribute :parameters

          def package_imports(packages)
            @package_imports ||= []
            @package_imports.concat(Array(packages))
          end

          def package_import(package)
            package_imports([package])
          end

          def include_files(files)
            @include_files ||= []
            @include_files.concat(Array(files))
          end

          def include_file(file)
            include_files([file])
          end

          private

          def header_code(code)
            code << ['package', space, name, semicolon]
          end

          def pre_body_code(code)
            package_import_declaration(code)
            file_include_directives(code)
            parameter_declarations(code)
          end

          def package_import_declaration(code)
            declarations =
              @package_imports
                &.map { |package| ['import', space, package, '::*'] }
            declarations &&
              add_declarations_to_body(code, declarations)
          end

          def file_include_directives(code)
            @include_files&.each do |file|
              code << ['`include', space, string(file), nl]
            end
          end

          def parameter_declarations(code)
            parameters &&
              add_declarations_to_body(code, parameters)
          end

          def footer_code
            'endpackage'
          end
        end
      end
    end
  end
end
