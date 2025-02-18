# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module BitFieldIndex
        EXPORTED_METHODS = [
          :local_index, :local_indexes, :loop_variables, :flat_loop_index, :array_size
        ].freeze

        def self.included(feature)
          feature.module_eval do
            EXPORTED_METHODS.each { |m| export m }
          end
        end

        def local_index
          create_identifier(local_index_name)
        end

        def local_indexes
          [*register.local_indexes, local_index_name]
        end

        def loop_variables
          (inside_loop? || nil) &&
            [*register.loop_variables, local_index].compact
        end

        def flat_loop_index
          return unless inside_loop?

          size = array_size
          factors =
            Array.new(size.size) { |i| size[(i + 1)..].inject(1, :*) }
          factors
            .zip(loop_variables)
            .map { |f, v| f == 1 && v || "#{f}*#{v}" }
            .join('+')
        end

        def array_size
          return unless inside_loop?

          [*register.array_size(hierarchical: true), *bit_field.sequence_size]
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
