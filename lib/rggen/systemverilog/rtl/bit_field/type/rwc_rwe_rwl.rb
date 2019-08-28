# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rwc, :rwe, :rwl]) do
  sv_rtl do
    build do
      if clear_port?
        input :register_block, :clear, {
          name: "i_#{full_name}_clear", data_type: :logic, width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      if enable_port?
        input :register_block, :enable, {
          name: "i_#{full_name}_enable", data_type: :logic, width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      if lock_port?
        input :register_block, :lock, {
          name: "i_#{full_name}_lock", data_type: :logic, width: 1,
          array_size: array_size, array_format: array_port_format
        }
      end
      output :register_block, :value_out, {
        name: "o_#{full_name}", data_type: :logic, width: width,
        array_size: array_size, array_format: array_port_format
      }
    end

    main_code :bit_field, from_template: true

    private

    def clear_port?
      bit_field.type == :rwc && !bit_field.reference?
    end

    def enable_port?
      bit_field.type == :rwe && !bit_field.reference?
    end

    def lock_port?
      bit_field.type == :rwl && !bit_field.reference?
    end

    def control_signal
      reference_bit_field || control_port[loop_variables]
    end

    def control_port
      case bit_field.type
      when :rwc
        clear
      when :rwe
        enable
      when :rwl
        lock
      end
    end
  end
end
