# frozen_string_literal: true

RgGen.define_simple_feature(:register, :sv_rtl_top) do
  sv_rtl do
    include RgGen::SystemVerilog::RTL::RegisterIndex

    build do
      unless register.bit_fields.empty?
        interface :bit_field_if, {
          name: 'bit_field_if',
          interface_type: 'rggen_bit_field_if',
          parameter_values: [register.width]
        }
      end
    end

    main_code :register_block do
      local_scope("g_#{register.name}") do |scope|
        scope.top_scope
        scope.loop_size loop_size
        scope.variables variables
        scope.body(&method(:body_code))
      end
    end

    private

    def loop_size
      (register.array? || nil) &&
        loop_variables.zip(register.array_size).to_h
    end

    def variables
      register.declarations[:variable]
    end

    def body_code(code)
      register.generate_code(code, :register, :top_down)
    end
  end
end
