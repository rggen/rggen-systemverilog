# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class LocalScope < StructureDefinition
          define_attribute :name
          define_attribute :parameters
          define_attribute :variables
          define_attribute :loop_size

          def top_scope
            @top_scope = true
          end

          private

          def header_code(code)
            code << [:generate, space] if @top_scope
            code << "if (1) begin : #{name}" << nl
          end

          def footer_code(code)
            code << :end
            code << [space, :endgenerate] if @top_scope
          end

          def pre_body_code(code)
            genvar_declarations(code)
            generate_for_header(code)
            parameter_declarations(code)
            variable_declarations(code)
          end

          def genvar_declarations(code)
            genvars = Array(loop_size&.keys).map { |genvar| "genvar #{genvar}" }
            add_declarations_to_body(code, genvars)
          end

          def generate_for_header(code)
            loop_size&.each do |genvar, size|
              code << generate_for(genvar, size) << nl
              code.indent += 2
            end
          end

          def generate_for(genvar, size)
            "for (#{genvar} = 0;#{genvar} < #{size};++#{genvar}) begin : g"
          end

          def parameter_declarations(code)
            add_declarations_to_body(code, Array(parameters))
          end

          def variable_declarations(code)
            add_declarations_to_body(code, Array(variables))
          end

          def post_body_code(code)
            (loop_size&.size || 0).times do
              code.indent -= 2
              code << :end << nl
            end
          end
        end
      end
    end
  end
end
