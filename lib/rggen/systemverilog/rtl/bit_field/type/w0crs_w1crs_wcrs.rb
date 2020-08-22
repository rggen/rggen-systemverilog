# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0crs, :w1crs, :wcrs]) do
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
      value = { w0crs: 0b00, w1crs: 0b01, wcrs: 0b10 }[bit_field.type]
      bin(value, 2)
    end
  end
end
