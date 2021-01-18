# frozen_string_literal: true

RgGen.define_list_item_feature(
  :bit_field, :type, [:w0crs, :w0src, :w1crs, :w1src, :wcrs, :wsrc]
) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def read_action
      read_set? && 'RGGEN_READ_SET' || 'RGGEN_READ_CLEAR'
    end

    def read_set?
      [:w0crs, :w1crs, :wcrs].include?(bit_field.type)
    end

    def write_action
      {
        w0crs: 'RGGEN_WRITE_0_CLEAR',
        w0src: 'RGGEN_WRITE_0_SET',
        w1crs: 'RGGEN_WRITE_1_CLEAR',
        w1src: 'RGGEN_WRITE_1_SET',
        wcrs: 'RGGEN_WRITE_CLEAR',
        wsrc: 'RGGEN_WRITE_SET'
      }[bit_field.type]
    end
  end
end
