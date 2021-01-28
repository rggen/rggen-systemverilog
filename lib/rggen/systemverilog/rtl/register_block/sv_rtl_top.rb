# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :sv_rtl_top) do
  sv_rtl do
    export :total_registers

    build do
      input :clock, { name: 'i_clk', width: 1 }
      input :reset, { name: 'i_rst_n', width: 1 }
      interface :register_if, {
        name: 'register_if', interface_type: 'rggen_register_if',
        parameter_values: [address_width, bus_width, value_width],
        array_size: [total_registers], variables: ['value']
      }
    end

    write_file '<%= register_block.name %>.sv' do |file|
      file.body(&method(:body_code))
    end

    def total_registers
      register_block.files_and_registers.sum(&:count)
    end

    private

    def address_width
      register_block.local_address_width
    end

    def bus_width
      configuration.bus_width
    end

    def value_width
      register_block.registers.map(&:width).max
    end

    def body_code(code)
      macro_definition(code)
      sv_module_definition(code)
    end

    def macro_definition(code)
      code << process_template(File.join(__dir__, 'sv_rtl_macros.erb'))
    end

    def sv_module_definition(code)
      code << module_definition(register_block.name) do |sv_module|
        sv_module.package_imports packages
        sv_module.parameters parameters
        sv_module.ports ports
        sv_module.variables variables
        sv_module.body(&method(:sv_module_body))
      end
    end

    def packages
      ['rggen_rtl_pkg', *register_block.package_imports(:register_block)]
    end

    def parameters
      register_block.declarations[:parameter]
    end

    def ports
      register_block.declarations[:port]
    end

    def variables
      register_block.declarations[:variable]
    end

    def sv_module_body(code)
      { register_block: nil, register_file: 1 }.each do |kind, depth|
        register_block.generate_code(code, kind, :top_down, depth)
      end
    end
  end
end
