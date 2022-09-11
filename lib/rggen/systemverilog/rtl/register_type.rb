# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module RegisterType
        include PartialSum

        private

        def readable
          register.readable? && 1 || 0
        end

        def writable
          register.writable? && 1 || 0
        end

        def bus_width
          configuration.bus_width
        end

        def address_width
          register_block.local_address_width
        end

        def offset_address
          [*register_files, register]
            .flat_map(&method(:collect_offsets))
            .then(&method(:partial_sums))
            .then(&method(:format_offsets))
        end

        def collect_offsets(component)
          if component.register_file? && component.array?
            [component.offset_address, byte_offset(component)]
          else
            component.offset_address
          end
        end

        def byte_offset(component)
          "#{component.byte_size(false)}*(#{component.local_index})"
        end

        def format_offsets(offsets)
          offsets.map(&method(:format_offset)).join('+')
        end

        def format_offset(offset)
          offset.is_a?(Integer) ? hex(offset, address_width) : offset
        end

        def width
          register.width
        end

        def valid_bits
          bits = register.bit_fields.map(&:bit_map).inject(:|)
          hex(bits, register.width)
        end

        def register_index
          register.local_index || 0
        end
      end
    end
  end
end
