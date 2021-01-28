# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :external) do
  sv_rtl do
    build do
      if configuration.fold_sv_interface_port?
        interface_port :bus_if, {
          name: "#{register.name}_bus_if",
          interface_type: 'rggen_bus_if',
          modport: 'master'
        }
      else
        output :valid, {
          name: "o_#{register.name}_valid", width: 1
        }
        output :access, {
          name: "o_#{register.name}_access", width: '$bits(rggen_access)'
        }
        output :address, {
          name: "o_#{register.name}_address", width: address_width
        }
        output :write_data, {
          name: "o_#{register.name}_data", width: bus_width
        }
        output :strobe, {
          name: "o_#{register.name}_strobe", width: byte_width
        }
        input :ready, {
          name: "i_#{register.name}_ready", width: 1
        }
        input :status, {
          name: "i_#{register.name}_status", width: 2
        }
        input :read_data, {
          name: "i_#{register.name}_data", width: bus_width
        }
        interface :bus_if, {
          name: 'bus_if', interface_type: 'rggen_bus_if',
          parameter_values: [address_width, bus_width],
          variables: [
            'valid', 'access', 'address', 'write_data', 'strobe',
            'ready', 'status', 'read_data'
          ]
        }
      end
    end

    main_code :register, from_template: true
    main_code :register do |code|
      unless configuration.fold_sv_interface_port?
        [
          [valid, bus_if.valid],
          [access, bus_if.access],
          [address, bus_if.address],
          [write_data, bus_if.write_data],
          [strobe, bus_if.strobe],
          [bus_if.ready, ready],
          [bus_if.status, "rggen_status'(#{status})"],
          [bus_if.read_data, read_data]
        ].map { |lhs, rhs| code << assign(lhs, rhs) << nl }
      end
    end

    private

    def byte_width
      configuration.byte_width
    end

    def start_address
      hex(register.offset_address, address_width)
    end

    def end_address
      address = register.offset_address + register.byte_size - 1
      hex(address, address_width)
    end
  end
end
