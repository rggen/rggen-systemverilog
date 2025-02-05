# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :avalon) do
  register_map do
    verify(:component) do
      error_condition { configuration.address_width > 64 }
      message do
        'address width over 64 bits is not supported: ' \
        "#{configuration.address_width}"
      end
      position do
        configuration.feature(:address_width).position
      end
    end

    verify(:component) do
      error_condition { register_block.bus_width > 1024 }
      message do
        'bus width over 1024 bits is not supported: ' \
        "#{register_block.bus_width}"
      end
      position do
        register_block.feature(:bus_width).position
      end
    end
  end

  sv_rtl do
    build do
      interface_port :avalon_if, {
        name: 'avalon_if', interface_type: 'rggen_avalon_if', modport: 'agent'
      }
    end

    main_code :register_block, from_template: true
  end
end
