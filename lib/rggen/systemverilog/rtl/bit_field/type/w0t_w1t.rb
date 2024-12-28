# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0t, :w1t]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", width:,
        array_size:, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def write_action
      {
        w0t: 'RGGEN_WRITE_0_TOGGLE',
        w1t: 'RGGEN_WRITE_1_TOGGLE'
      }[bit_field.type]
    end
  end
end
