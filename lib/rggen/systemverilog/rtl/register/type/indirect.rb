# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  sv_rtl do
    build do
      logic :register, :indirect_index, { width: index_width }
    end

    main_code :register do |code|
      code << indirect_index_assignment << nl
      code << process_template
    end

    private

    def index_fields
      @index_fields ||=
        register.collect_index_fields(register_block.bit_fields)
    end

    def index_width
      @index_width ||= index_fields.map(&:width).sum
    end

    def index_values
      loop_variables = register.loop_variables
      register.index_entries.zip(index_fields).map do |entry, field|
        if entry.array_index?
          loop_variables.shift[0, field.width]
        else
          hex(entry.value, field.width)
        end
      end
    end

    def indirect_index_assignment
      assign(indirect_index, concat(index_fields.map(&:value)))
    end
  end
end
