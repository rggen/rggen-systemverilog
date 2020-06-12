# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rs, :w0s, :w1s]) do
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
      if bit_field.type == :rs
        'rggen_bit_field_rs'
      else
        'rggen_bit_field_w01s'
      end
    end

    def set_value
      bin({ w0s: 0, w1s: 1 }[bit_field.type], 1)
    end
  end
end
