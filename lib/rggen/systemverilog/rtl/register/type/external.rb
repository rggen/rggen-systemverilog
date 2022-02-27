# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :external) do
  sv_rtl do
    build do
      interface_port :bus_if, {
        name: "#{register.name}_bus_if",
        interface_type: 'rggen_bus_if',
        modport: 'master'
      }
    end

    main_code :register, from_template: true

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
