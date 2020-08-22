# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rs, :w0s, :w1s, :ws, :wos]) do
  sv_rtl do
    build do
      input :clear, {
        name: "i_#{full_name}_clear", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def module_name
      bit_field.type == :rs && 'rggen_bit_field_rs' || 'rggen_bit_field_w01s_ws_wos'
    end

    def set_value
      value = { w0s: 0b00, w1s: 0b01, ws: 0b10, wos: 0b10 }[bit_field.type]
      bin(value, 2)
    end

    def write_only
      bit_field.write_only? && 1 || 0
    end
  end
end
