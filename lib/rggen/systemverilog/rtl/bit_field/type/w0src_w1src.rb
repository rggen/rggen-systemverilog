# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0src, :w1src]) do
  sv_rtl do
    build do
      output :register_block, :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def set_value
      value = (bit_field.type == :w0src && 0) || 1
      bin(value, 1)
    end
  end
end
