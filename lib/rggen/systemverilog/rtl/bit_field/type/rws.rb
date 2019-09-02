# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rws) do
  sv_rtl do
    build do
      unless bit_field.reference?
        input :register_block, :set, {
          name: "i_#{full_name}_set", data_type: :logic, width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      input :register_block, :value_in, {
        name: "i_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
      output :register_block, :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def set_signal
      reference_bit_field || set[loop_variables]
    end
  end
end
