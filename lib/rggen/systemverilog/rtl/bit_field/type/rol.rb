# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rol) do
  sv_rtl do
    build do
      unless bit_field.reference?
        input :latch, {
          name: "i_#{full_name}_latch", width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      input :value_in, {
        name: "i_#{full_name}", width: width,
        array_size: array_size, array_format: array_port_format
      }
      output :value_out, {
        name: "o_#{full_name}", width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def latch_signal
      reference_bit_field || latch[loop_variables]
    end
  end
end
