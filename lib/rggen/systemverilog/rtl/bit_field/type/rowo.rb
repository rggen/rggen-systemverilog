# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rowo) do
  sv_rtl do
    build do
      output :value_out, {
        name: "o_#{full_name}", width: width,
        array_size: array_size, array_format: array_port_format
      }
      unless bit_field.reference?
        input :value_in, {
          name: "i_#{full_name}", width: width,
          array_size: array_size, array_format: array_port_format
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def reference_or_value_in
      reference_bit_field || value_in[loop_variables]
    end
  end
end
