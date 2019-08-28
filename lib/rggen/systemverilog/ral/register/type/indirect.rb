# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  sv_ral do
    unmapped
    offset_address { register.offset_address }

    main_code :ral_package do
      class_definition(model_name) do |sv_class|
        sv_class.base 'rggen_ral_indirect_reg'
        sv_class.variables variables
        sv_class.body { process_template }
      end
    end

    private

    def index_properties
      array_position = -1
      register.index_entries.zip(index_fields).map do |entry, field|
        value =
          if entry.value_index?
            hex(entry.value, field.width)
          else
            "array_index[#{array_position += 1}]"
          end
        [field.register.name, field.name, value]
      end
    end

    def index_fields
      register.collect_index_fields(register_block.bit_fields)
    end
  end
end
