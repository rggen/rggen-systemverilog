# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :apb) do
  configuration do
    verify(:component) do
      error_condition { configuration.address_width > 32 }
      message do
        'address width over 32 bits is not supported: ' \
        "#{configuration.address_width}"
      end
    end
  end

  register_map do
    verify(:component) do
      error_condition { register_block.bus_width > 32 }
      message do
        'bus width over 32 bits is not supported: ' \
        "#{register_block.bus_width}"
      end
      position do
        register_block.feature(:bus_width).position
      end
    end
  end

  sv_rtl do
    build do
      interface_port :apb_if, {
        name: 'apb_if', interface_type: 'rggen_apb_if', modport: 'slave'
      }
    end

    main_code :register_block, from_template: true
  end
end
