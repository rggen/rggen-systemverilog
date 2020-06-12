# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0crs, :w1crs]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def clear_value
      value = (bit_field.type == :w0crs && 0) || 1
      bin(value, 1)
    end
  end
end
