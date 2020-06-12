# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :apb) do
  configuration do
    verify(:component) do
      error_condition { configuration.bus_width > 32 }
      message do
        'bus width over 32 bit is not supported: ' \
        "#{configuration.bus_width}"
      end
    end

    verify(:component) do
      error_condition { configuration.address_width > 32 }
      message do
        'address width over 32 bit is not supported: ' \
        "#{configuration.address_width}"
      end
    end
  end

  sv_rtl do
    build do
      if configuration.fold_sv_interface_port?
        interface_port :apb_if, {
          name: 'apb_if', interface_type: 'rggen_apb_if', modport: 'slave'
        }
      else
        input :psel, {
          name: 'i_psel', data_type: :logic, width: 1
        }
        input :penable, {
          name: 'i_penable', data_type: :logic, width: 1
        }
        input :paddr, {
          name: 'i_paddr', data_type: :logic, width: address_width
        }
        input :pprot, {
          name: 'i_pprot', data_type: :logic, width: 3
        }
        input :pwrite, {
          name: 'i_pwrite', data_type: :logic, width: 1
        }
        input :pstrb, {
          name: 'i_pstrb', data_type: :logic, width: byte_width
        }
        input :pwdata, {
          name: 'i_pwdata', data_type: :logic, width: bus_width
        }
        output :pready, {
          name: 'o_pready', data_type: :logic, width: 1
        }
        output :prdata, {
          name: 'o_prdata', data_type: :logic, width: bus_width
        }
        output :pslverr, {
          name: 'o_pslverr', data_type: :logic, width: 1
        }
        interface :apb_if, {
          name: 'apb_if', interface_type: 'rggen_apb_if',
          parameter_values: [address_width, bus_width],
          variables: [
            'psel', 'penable', 'paddr', 'pprot', 'pwrite', 'pstrb', 'pwdata',
            'pready', 'prdata', 'pslverr'
          ]
        }
      end
    end

    main_code :register_block, from_template: true
    main_code :register_block do |code|
      unless configuration.fold_sv_interface_port?
        [
          [apb_if.psel, psel],
          [apb_if.penable, penable],
          [apb_if.paddr, paddr],
          [apb_if.pprot, pprot],
          [apb_if.pwrite, pwrite],
          [apb_if.pstrb, pstrb],
          [apb_if.pwdata, pwdata],
          [pready, apb_if.pready],
          [prdata, apb_if.prdata],
          [pslverr, apb_if.pslverr]
        ].each { |lhs, rhs| code << assign(lhs, rhs) << nl }
      end
    end
  end
end
