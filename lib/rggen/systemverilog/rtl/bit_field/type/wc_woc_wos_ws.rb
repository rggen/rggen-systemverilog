# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:wc, :woc, :wos, :ws]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def module_name
      [:wc, :woc].include?(bit_field.type) &&
        'rggen_bit_field_wc_woc' || 'rggen_bit_field_ws_wos'
    end

    def write_only
      bit_field.write_only? && 1 || 0
    end
  end
end
