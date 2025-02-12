# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rwe, :rwl]) do
  sv_rtl do
    build do
      unless bit_field.reference?
        input :control, {
          name: "i_#{full_name}_#{enable_or_lock}", width: 1, array_size:
        }
      end
      output :value_out, {
        name: "o_#{full_name}", width:, array_size:
      }
    end

    main_code :bit_field, from_template: true

    private

    def enable_or_lock
      { rwe: :enable, rwl: :lock }[bit_field.type]
    end

    def control_signal
      reference_bit_field || control[loop_variables]
    end

    def polarity
      { rwe: 'RGGEN_ACTIVE_HIGH', rwl: 'RGGEN_ACTIVE_LOW' }[bit_field.type]
    end
  end
end
