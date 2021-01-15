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

    def write_action
      {
        w0crs: 'RGGEN_WRITE_0_CLEAR',
        w1crs: 'RGGEN_WRITE_1_CLEAR',
        wcrs: 'RGGEN_WRITE_CLEAR'
      }[bit_field.type]
    end
  end
end
