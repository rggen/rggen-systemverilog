# frozen_string_literal: true

require 'docile'
require 'facets/kernel/attr_singleton'

require_relative 'systemverilog/version'

require_relative 'systemverilog/utility/identifier'
require_relative 'systemverilog/utility/data_object'
require_relative 'systemverilog/utility/interface_port'
require_relative 'systemverilog/utility/interface_instance'
require_relative 'systemverilog/utility/structure_definition'
require_relative 'systemverilog/utility/module_definition'
require_relative 'systemverilog/utility'

require_relative 'systemverilog/component'
require_relative 'systemverilog/feature'
require_relative 'systemverilog/feature_rtl'
require_relative 'systemverilog/feature_ral'

module RgGen
  module SystemVerilog
    def self.setup(builder, name, feature)
      builder.output_component_registry(name) do
        register_component :register_map do
          component Component
          component_factory Core::OutputBase::ComponentFactory
        end

        register_component [:register_block, :register, :bit_field] do
          component Component
          component_factory Core::OutputBase::ComponentFactory
          base_feature feature
          feature_factory Core::OutputBase::FeatureFactory
        end
      end
    end

    def self.setup_rtl(builder)
      setup(builder, :sv_rtl, FeatureRTL)
    end

    def self.setup_ral(builder)
      setup(builder, :sv_ral, FeatureRAL)
    end
  end

  setup do |builder|
    SystemVerilog.setup_rtl(builder)
    SystemVerilog.setup_ral(builder)
  end
end
