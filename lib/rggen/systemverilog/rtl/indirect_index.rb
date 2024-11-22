# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module IndirectIndex
        private

        def index_fields
          @index_fields ||=
            register
              .collect_index_fields(register_block.bit_fields)
        end

        def index_match_width
          index_fields.size
        end

        def index_values
          @index_values ||= collect_index_values
        end

        def collect_index_values
          loop_variables = register.local_loop_variables
          register.index_entries.zip(index_fields).map do |entry, field|
            if entry.array_index?
              array_index_value(loop_variables.shift, field.width)
            else
              fixed_index_value(entry.value, field.width)
            end
          end
        end

        def array_index_value(value, width)
          "#{width}'(#{value})"
        end

        def fixed_index_value(value, width)
          hex(value, width)
        end

        def indirect_index_matches(code)
          index_fields.each_with_index do |field, i|
            rhs = index_match_rhs(i)
            lhs = index_match_lhs(field.value, index_values[i])
            code << assign(rhs, lhs) << nl
          end
        end

        def index_match_rhs(index)
          if index_match_width == 1
            indirect_match
          else
            indirect_match[index]
          end
        end

        def index_match_lhs(field, value)
          "#{field} == #{value}"
        end
      end
    end
  end
end
