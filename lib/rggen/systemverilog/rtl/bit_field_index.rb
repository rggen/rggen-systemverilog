# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module BitFieldIndex
        EXPORTED_METHODS = [
          :local_index, :local_indices, :loop_variables, :array_size
        ].freeze

        def self.included(feature)
          feature.module_eval do
            EXPORTED_METHODS.each { |m| export m }
          end
        end

        def local_index
          create_identifier(local_index_name)
        end

        def local_indices
          [*register.local_indices, local_index_name]
        end

        def loop_variables
          (inside_loop? || nil) &&
            [*register.loop_variables, local_index].compact
        end

        def array_size
          (inside_loop? || nil) &&
            [
              *register_files.flat_map(&:array_size),
              *register.array_size,
              *bit_field.sequence_size
            ].compact
        end

        private

        def local_index_name
          (bit_field.sequential? || nil) &&
            loop_index((register.loop_variables&.size || 0) + 1)
        end

        def inside_loop?
          register.inside_loop? || bit_field.sequential?
        end
      end
    end
  end
end
