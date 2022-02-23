# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rotrg, :rwtrg, :wotrg]) do
  sv_ral do
    access do
      { rotrg: :ro, rwtrg: :rw, wotrg: :wo }[bit_field.type]
    end
  end
end
