# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, :rowo) do
  sv_ral do
    model_name { 'rggen_ral_rowo_field' }
  end
end
