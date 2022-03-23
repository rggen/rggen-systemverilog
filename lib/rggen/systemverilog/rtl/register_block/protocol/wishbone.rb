# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :wishbone) do
  configuration do
    verify(:component) do
      error_condition { configuration.bus_width > 64 }
      message do
        'bus width over 64 bit is not supported: ' \
        "#{configuration.bus_width}"
      end
    end
  end

  sv_rtl do
    build do
      parameter :use_stall, {
        name: 'USE_STALL', data_type: :bit, default: 1
      }
      interface_port :wishbone_if, {
        name: 'wishbone_if', interface_type: 'rggen_wishbone_if', modport: 'slave'
      }
    end

    main_code :register_block, from_template: true
  end
end
