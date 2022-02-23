# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rowo, :rowotrg]) do
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
      if rowotrg?
        output :write_trigger, {
          name: "o_#{full_name}_write_trigger", width: 1,
          array_size: array_size, array_format: array_port_format
        }
        output :read_trigger, {
          name: "o_#{full_name}_read_trigger", width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
    end

    main_code :bit_field, from_template: true

    private

    def rowotrg?
      bit_field.type == :rowotrg
    end

    def trigger
      rowotrg? && 1 || 0
    end

    def write_trigger_signal
      rowotrg? && write_trigger[loop_variables] || nil
    end

    def read_trigger_signal
      rowotrg? && read_trigger[loop_variables] || nil
    end

    def reference_or_value_in
      reference_bit_field || value_in[loop_variables]
    end
  end
end
