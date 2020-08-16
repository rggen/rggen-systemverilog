# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0t, :w1t]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def toggle_value
      bin({ w0t: 0, w1t: 1 }[bit_field.type], 1)
    end
  end
end
