# frozen_string_literal: true

RgGen.define_list_item_feature(:register_block, :protocol, :axi4lite) do
  configuration do
    verify(:component) do
      error_condition { ![32, 64].include?(configuration.bus_width) }
      message do
        'bus width eigher 32 bit or 64 bit is only supported: ' \
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
      if configuration.fold_sv_interface_port?
        interface_port :axi4lite_if, {
          name: 'axi4lite_if',
          interface_type: 'rggen_axi4lite_if', modport: 'slave'
        }
      else
        input :awvalid, {
          name: 'i_awvalid', data_type: :logic, width: 1
        }
        output :awready, {
          name: 'o_awready', data_type: :logic, width: 1
        }
        input :awid, {
          name: 'i_awid', data_type: :logic, width: id_port_width
        }
        input :awaddr, {
          name: 'i_awaddr', data_type: :logic, width: address_width
        }
        input :awprot, {
          name: 'i_awprot', data_type: :logic, width: 3
        }
        input :wvalid, {
          name: 'i_wvalid', data_type: :logic, width: 1
        }
        output :wready, {
          name: 'o_wready', data_type: :logic, width: 1
        }
        input :wdata, {
          name: 'i_wdata', data_type: :logic, width: bus_width
        }
        input :wstrb, {
          name: 'i_wstrb', data_type: :logic, width: byte_width
        }
        output :bvalid, {
          name: 'o_bvalid', data_type: :logic, width: 1
        }
        output :bid, {
          name: 'o_bid', data_type: :logic, width: id_port_width
        }
        input :bready, {
          name: 'i_bready', data_type: :logic, width: 1
        }
        output :bresp, {
          name: 'o_bresp', data_type: :logic, width: 2
        }
        input :arvalid, {
          name: 'i_arvalid', data_type: :logic, width: 1
        }
        output :arready, {
          name: 'o_arready', data_type: :logic, width: 1
        }
        input :arid, {
          name: 'i_arid', data_type: :logic, width: id_port_width
        }
        input :araddr, {
          name: 'i_araddr', data_type: :logic, width: address_width
        }
        input :arprot, {
          name: 'i_arprot', data_type: :logic, width: 3
        }
        output :rvalid, {
          name: 'o_rvalid', data_type: :logic, width: 1
        }
        input :rready, {
          name: 'i_rready', data_type: :logic, width: 1
        }
        output :rid, {
          name: 'o_rid', data_type: :logic, width: id_port_width
        }
        output :rdata, {
          name: 'o_rdata', data_type: :logic, width: bus_width
        }
        output :rresp, {
          name: 'o_rresp', data_type: :logic, width: 2
        }
        interface :axi4lite_if, {
          name: 'axi4lite_if', interface_type: 'rggen_axi4lite_if',
          parameter_values: [id_width, address_width, bus_width],
          variables: [
            'awvalid', 'awready', 'awid', 'awaddr', 'awprot',
            'wvalid', 'wready', 'wdata', 'wstrb',
            'bvalid', 'bready', 'bid', 'bresp',
            'arvalid', 'arready', 'arid', 'araddr', 'arprot',
            'rvalid', 'rready', 'rid', 'rdata', 'rresp'
          ]
        }
      end
    end

    main_code :register_block, from_template: true
    main_code :register_block do |code|
      configuration.fold_sv_interface_port? || assign_axi4lite_signals(code)
    end

    private

    def id_port_width
      "((#{id_width}>0)?#{id_width}:1)"
    end

    def assign_axi4lite_signals(code)
      [
        [axi4lite_if.awvalid, awvalid],
        [awready, axi4lite_if.awready],
        [axi4lite_if.awid, awid],
        [axi4lite_if.awaddr, awaddr],
        [axi4lite_if.awprot, awprot],
        [axi4lite_if.wvalid, wvalid],
        [wready, axi4lite_if.wready],
        [axi4lite_if.wdata, wdata],
        [axi4lite_if.wstrb, wstrb],
        [bvalid, axi4lite_if.bvalid],
        [axi4lite_if.bready, bready],
        [bid, axi4lite_if.bid],
        [bresp, axi4lite_if.bresp],
        [axi4lite_if.arvalid, arvalid],
        [arready, axi4lite_if.arready],
        [axi4lite_if.arid, arid],
        [axi4lite_if.araddr, araddr],
        [axi4lite_if.arprot, arprot],
        [rvalid, axi4lite_if.rvalid],
        [axi4lite_if.rready, rready],
        [rid, axi4lite_if.rid],
        [rdata, axi4lite_if.rdata],
        [rresp, axi4lite_if.rresp]
      ].each { |lhs, rhs| code << assign(lhs, rhs) << nl }
    end
  end
end
