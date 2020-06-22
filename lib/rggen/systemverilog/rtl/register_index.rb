# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module RegisterIndex
        def self.included(feature)
          feature.module_eval do
            export :loop_variables
            export :local_index
            export :local_indices
            export :index
            export :inside_roop?

            pre_build do
              @base_index = files_and_registers.sum(&:count)
            end
          end
        end

        def loop_variables
          (inside_roop? || nil) &&
            [*upper_register_file&.loop_variables, *local_loop_variables]
        end

        def local_index
          (component.array? || nil) &&
            local_index_coefficients
              .zip(local_loop_variables)
              .map { |operands| product(operands, false) }
              .join('+')
        end

        def local_indices
          [*upper_register_file&.local_indices, local_index]
        end

        def index(offset_or_offsets = nil)
          operands = index_operands(offset_or_offsets)
          if operands.empty? || operands.all? { |operand| operand.is_a?(Integer) }
            operands.sum
          else
            operands.join('+')
          end
        end

        def inside_roop?
          component.array? || upper_register_file&.inside_roop? || false
        end

        private

        def upper_register_file
          component.register_file
        end

        def local_loop_variables
          (component.array? || nil) &&
            begin
              start_depth = (upper_register_file&.loop_variables&.size || 0) + 1
              Array.new(component.array_size.size) do |i|
                create_identifier(loop_index(i + start_depth))
              end
            end
        end

        def local_index_coefficients
          coefficients = []
          component.array_size.reverse.inject(1) do |total, size|
            coefficients.unshift(total)
            total * size
          end
          coefficients
        end

        def index_operands(offset_or_offsets)
          offsets = offset_or_offsets && Array(offset_or_offsets)
          [
            *upper_register_file&.index(offsets&.slice(0..-2)),
            @base_index,
            *local_register_index(offsets&.slice(-1))
          ].reject { |operand| operand.is_a?(Integer) && operand.zero? }
        end

        def local_register_index(offset)
          (component.array? || nil) &&
            begin
              operands = [component.count(false), offset || local_index]
              product(operands, true)
            end
        end

        def product(operands, need_bracket)
          if operands.all? { |operand| operand.is_a?(Integer) }
            operands.reduce(:*)
          elsif operands.first == 1
            operands.last
          elsif need_bracket
            "#{operands.first}*(#{operands.last})"
          else
            operands.join('*')
          end
        end
      end
    end
  end
end
