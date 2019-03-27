# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilog
      def self.setup_rtl(builder)
        builder.input_component_registry(:sv_rtl) do
          register_component :register_map do
            component Component
            component_factory Core::OutputBase::ComponentFactory
          end

          register_component [:register_block, :register, :bit_field] do
            component Component
            component_factory Core::OutputBase::ComponentFactory
            base_feature FeatureRTL
            feature_factory Core::OutputBase::FeatureFactory
          end
        end
      end

      def self.setup_ral(builder)
        builder.input_component_registry(:sv_ral) do
          register_component :register_map do
            component Component
            component_factory Core::OutputBase::ComponentFactory
          end

          register_component [:register_block, :register, :bit_field] do
            component Component
            component_factory Core::OutputBase::ComponentFactory
            base_feature FeatureRAL
            feature_factory Core::OutputBase::FeatureFactory
          end
        end
      end
    end
  end
end
