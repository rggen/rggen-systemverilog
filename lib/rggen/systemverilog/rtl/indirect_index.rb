# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module IndirectIndex
        private

        def index_fields
          @index_fields ||=
            register.collect_index_fields(register_block.bit_fields)
        end

        def index_width
          @index_width ||= index_fields.sum(&:width)
        end

        def index_values
          loop_variables = register.local_loop_variables
          register.index_entries.zip(index_fields).map do |entry, field|
            if entry.array_index?
              loop_variables.shift[0, field.width]
            else
              hex(entry.value, field.width)
            end
          end
        end

        def indirect_index_assignment
          assign(indirect_index, concat(index_fields.map(&:value)))
        end
      end
    end
  end
end
