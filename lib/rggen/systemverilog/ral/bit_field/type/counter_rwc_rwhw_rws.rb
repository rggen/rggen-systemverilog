# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:counter, :rwc, :rwhw, :rws]) do
  sv_ral { access 'RW' }
end
