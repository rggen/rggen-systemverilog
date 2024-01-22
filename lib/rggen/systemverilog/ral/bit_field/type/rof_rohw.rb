# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rof, :rohw]) do
  sv_ral { access 'RO' }
end
