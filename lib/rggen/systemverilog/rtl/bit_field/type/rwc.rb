# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rwc) do
  sv_rtl do
    build do
      unless bit_field.reference?
        input :clear, {
          name: "i_#{full_name}_clear", width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      output :value_out, {
        name: "o_#{full_name}", width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def clear_signal
      reference_bit_field || clear[loop_variables]
    end
  end
end
