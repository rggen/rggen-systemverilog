# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  sv_rtl do
    base_feature do
      include RgGen::SystemVerilog::RTL::RegisterType

      pre_code :register do |code|
        register.bit_fields.empty? ||
          (code << tie_off_unused_signals << nl)
      end

      private

      def register_if
        register_block.register_if[register.index]
      end

      def bit_field_if
        register.bit_field_if
      end

      def tie_off_unused_signals
        macro_call(
          'rggen_tie_off_unused_signals',
          [width, valid_bits, bit_field_if]
        )
      end
    end

    default_feature do
      template_path = File.join(__dir__, 'type', 'default.erb')
      main_code :register, from_template: template_path
    end

    factory do
      def target_feature_key(_configuration, register)
        type = register.type
        (target_features.key?(type) || type == :default) && type ||
          begin
            error "code generator for #{type} register type " \
                  'is not implemented'
          end
      end
    end
  end
end
