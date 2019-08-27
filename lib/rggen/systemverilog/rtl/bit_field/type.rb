# frozen_string_literal: true

RgGen.define_list_feature(:bit_field, :type) do
  sv_rtl do
    base_feature do
      private

      def array_port_format
        configuration.array_port_format
      end

      def full_name
        bit_field.full_name('_')
      end

      def width
        bit_field.width
      end

      def array_size
        bit_field.array_size
      end

      def initial_value
        hex(bit_field.initial_value, bit_field.width)
      end

      def mask
        reference_bit_field ||
          hex(2**bit_field.width - 1, bit_field.width)
      end

      def reference_bit_field
        bit_field.reference? &&
          bit_field
            .find_reference(register_block.bit_fields)
            .value(
              register.local_index,
              bit_field.local_index,
              bit_field.reference_width
            )
      end

      def bit_field_if
        bit_field.bit_field_sub_if
      end

      def loop_variables
        bit_field.loop_variables
      end
    end

    factory do
      def select_feature(_configuration, bit_field)
        target_features[bit_field.type]
      end
    end
  end
end
