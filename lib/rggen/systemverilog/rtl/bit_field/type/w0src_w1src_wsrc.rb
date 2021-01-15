# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0src, :w1src, :wsrc]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def write_action
      {
        w0src: 'RGGEN_WRITE_0_SET',
        w1src: 'RGGEN_WRITE_1_SET',
        wsrc: 'RGGEN_WRITE_SET'
      }[bit_field.type]
    end
  end
end
