# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  sv_rtl do
    base_feature do
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
        hex(register.offset_address, address_width)
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

      def register_if
        register_block.register_if[register.index]
      end

      def bit_field_if
        register.bit_field_if
      end
    end

    default_feature do
      template_path = File.join(__dir__, 'type', 'default.erb')
      main_code :register, from_template: template_path
    end

    factory do
      def target_feature_key(_configuration, register)
        type = register.type
        (target_features.key?(type) || type == :default) && type ||
          begin
            error "code generator for #{type} register type " \
                  'is not implemented'
          end
      end
    end
  end
end
