# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rwe, :rwl]) do
  sv_ral do
    model_name do
      "rggen_ral_#{bit_field.type}_field"
    end
  end
end
