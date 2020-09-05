# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module RegisterIndex
        include PartialSum

        EXPORTED_METHODS = [
          :loop_variables, :local_loop_variables,
          :local_index, :local_indices,
          :index, :inside_loop?
        ].freeze

        def self.included(feature)
          feature.module_eval do
            EXPORTED_METHODS.each { |m| export m }

            pre_build do
              @base_index = files_and_registers.sum(&:count)
            end
          end
        end

        def loop_variables
          (inside_loop? || nil) &&
            [*upper_register_file&.loop_variables, *local_loop_variables]
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
          partial_indices = partial_sums(operands)
          if partial_indices.empty? || partial_indices.all?(&method(:integer?))
            partial_indices.sum
          else
            partial_indices.join('+')
          end
        end

        def inside_loop?
          component.array? || upper_register_file&.inside_loop? || false
        end

        private

        def upper_register_file
          component.register_file
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
          ]
        end

        def local_register_index(offset)
          (component.array? || nil) &&
            begin
              operands = [component.count(false), offset || local_index]
              product(operands, true)
            end
        end

        def product(operands, need_bracket)
          if operands.all?(&method(:integer?))
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
