# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :axi4lite) do
  configuration do
    verify(:component) do
      error_condition { ![32, 64].include?(configuration.bus_width) }
      message do
        'bus width either 32 bit or 64 bit is only supported: ' \
        "#{configuration.bus_width}"
      end
    end
  end

  sv_rtl do
    build do
      parameter :id_width, {
        name: 'ID_WIDTH', data_type: :int, default: 0
      }
      parameter :write_first, {
        name: 'WRITE_FIRST', data_type: :bit, default: 1
      }
      interface_port :axi4lite_if, {
        name: 'axi4lite_if',
        interface_type: 'rggen_axi4lite_if', modport: 'slave'
      }
    end

    main_code :register_block, from_template: true
  end
end
