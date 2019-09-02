# frozen_string_literal: true

RgGen.define_list_item_feature(:bit_field, :type, [:rwe, :rwl]) do
  sv_ral do
    model_name do
      "rggen_ral_#{bit_field.type}_field #(#{reference_names})"
    end

    private

    def reference_names
      reference = bit_field.reference
      register = reference&.register
      [register&.name, reference&.name]
        .map { |name| string(name) }
        .join(', ')
    end
  end
end
