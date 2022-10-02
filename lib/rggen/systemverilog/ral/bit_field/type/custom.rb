# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :custom) do
  sv_ral do
    model_name do
      'rggen_ral_custom_field ' \
        "#(#{sw_read}, #{sw_write}, #{write_once}, #{hw_update})"
    end

    private

    def sw_read
      string(bit_field.sw_read.upcase)
    end

    def sw_write
      string(bit_field.sw_write.upcase)
    end

    def write_once
      bit_field.sw_write_once? && 1 || 0
    end

    def hw_update
      bit_field.hw_update? && 1 || 0
    end
  end
end
