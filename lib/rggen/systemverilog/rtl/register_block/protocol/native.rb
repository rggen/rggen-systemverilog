# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :native) do
  sv_rtl do
    build do
      parameter :strobe_width, {
        name: 'STROBE_WIDTH', data_type: :int, default: bus_width / 8
      }
      parameter :use_read_strobe, {
        name: 'USE_READ_STROBE', data_type: :bit, default: 0
      }
      interface_port :csrbus_if, {
        name: 'csrbus_if', interface_type: 'rggen_bus_if', modport: 'slave'
      }
    end

    main_code :register_block, from_template: true
  end
end
