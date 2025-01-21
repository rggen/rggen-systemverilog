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

        def width
          register.width
        end

        def bus_width
          register_block.bus_width
        end

        def value_width
          register_block.value_width
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
          if need_byte_offset?(component)
            [component.offset_address, byte_offset(component)]
          else
            component.offset_address
          end
        end

        def need_byte_offset?(component)
          if component.register_file?
            component.array?
          else
            component.array? && !component.settings[:support_shared_address]
          end
        end

        def byte_offset(component)
          byte_size = component.entry_byte_size
          local_index = component.local_index
          if /[+\-*\/]/ =~ local_index
            "#{byte_size}*(#{local_index})"
          else
            "#{byte_size}*#{local_index}"
          end
        end

        def format_offsets(offsets)
          offsets.map(&method(:format_offset)).join('+')
        end

        def format_offset(offset)
          case offset
          when Integer then hex(offset, address_width)
          else width_cast(offset, address_width)
          end
        end

        def valid_bits
          bits = register.bit_fields.map(&:bit_map).inject(:|)
          hex(bits, width)
        end
      end
    end
  end
end
