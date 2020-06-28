# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RAL
      module RegisterCommon
        private

        def array_indices
          if component.array?
            index_table = component.array_size.map { |size| (0...size).to_a }
            index_table[0].product(*index_table[1..-1])
          else
            [nil]
          end
        end

        def offset_address(index)
          address =
            if register? && helper.offset_address
              instance_exec(index, &helper.offset_address)
            else
              default_offset_address(index)
            end
          hex(address, register_block.local_address_width)
        end

        def default_offset_address(index)
          component.offset_address + component.byte_size(false) * index
        end

        def hdl_path(array_index)
          [
            "g_#{component.name}",
            *Array(array_index).map { |i| "g[#{i}]" },
            *unit_instance_name
          ].join('.')
        end

        def unit_instance_name
          register? && 'u_register' || nil
        end
      end
    end
  end
end
