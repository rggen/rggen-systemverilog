# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:w0trg, :w1trg]) do
  sv_ral do
    model_name { "rggen_ral_#{bit_field.type}_field" }
  end
end
