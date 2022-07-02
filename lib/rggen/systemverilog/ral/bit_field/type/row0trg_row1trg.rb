# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:row0trg, :row1trg]) do
  sv_ral { access 'RO' }
end
