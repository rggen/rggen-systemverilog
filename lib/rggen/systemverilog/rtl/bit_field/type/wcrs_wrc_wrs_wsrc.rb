# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:wcrs, :wrc, :wrs, :wsrc]) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true
  end
end
