# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :indirect) do
  sv_rtl do
    include RgGen::SystemVerilog::RTL::IndirectIndex

    build do
      logic :indirect_match, { width: index_match_width }
    end

    main_code :register do |code|
      indirect_index_matches(code)
      code << process_template
    end
  end
end
