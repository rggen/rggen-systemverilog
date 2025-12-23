# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :counter) do
  sv_rtl do
    build do
      parameter :up_width, {
        name: "#{full_name}_up_width".upcase,
        data_type: :int, default: 1
      }
      parameter :down_width, {
        name: "#{full_name}_down_width".upcase,
        data_type: :int, default: 1
      }
      parameter :wrap_around, {
        name: "#{full_name}_wrap_around".upcase,
        data_type: :bit, default: 0
      }
      if external_clear?
        parameter :use_clear, {
          name: "#{full_name}_use_clear".upcase,
          data_type: :bit, default: 1
        }
      end

      input :up, {
        name: "i_#{full_name}_up",
        width: function_call(:rggen_clip_width, [up_width]), array_size:
      }
      input :down, {
        name: "i_#{full_name}_down",
        width: function_call(:rggen_clip_width, [down_width]), array_size:
      }
      if external_clear?
        input :clear, {
          name: "i_#{full_name}_clear", width: 1, array_size:
        }
      end
      output :count, {
        name: "o_#{full_name}", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def external_clear?
      !bit_field.reference?
    end

    def use_clear_value
      external_clear? && use_clear || 1
    end

    def clear_signal
      reference_bit_field || clear[loop_variables]
    end
  end
end
