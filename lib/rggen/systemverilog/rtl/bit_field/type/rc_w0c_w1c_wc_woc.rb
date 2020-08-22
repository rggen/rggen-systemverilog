# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rc, :w0c, :w1c, :wc, :woc]) do
  sv_rtl do
    build do
      input :set, {
        name: "i_#{full_name}_set", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
      if bit_field.reference?
        output :value_unmasked, {
          name: "o_#{full_name}_unmasked", data_type: :logic, width: width,
          array_size: array_size, array_format: array_port_format
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def module_name
      bit_field.type == :rc && 'rggen_bit_field_rc' || 'rggen_bit_field_w01c_wc_woc'
    end

    def clear_value
      value = { w0c: 0b00, w1c: 0b01, wc: 0b10, woc: 0b10 }[bit_field.type]
      bin(value, 2)
    end

    def write_only
      bit_field.write_only? && 1 || 0
    end

    def value_out_unmasked
      (bit_field.reference? || nil) &&
        value_unmasked[loop_variables]
    end
  end
end
