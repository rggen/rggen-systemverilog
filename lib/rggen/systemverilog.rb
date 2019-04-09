# frozen_string_literal: true

require 'docile'
require 'facets/kernel/attr_singleton'

require_relative 'systemverilog/version'

require_relative 'systemverilog/utility/identifier'
require_relative 'systemverilog/utility/data_object'
require_relative 'systemverilog/utility/interface_port'
require_relative 'systemverilog/utility/interface_instance'
require_relative 'systemverilog/utility/structure_definition'
require_relative 'systemverilog/utility/class_definition'
require_relative 'systemverilog/utility/function_definition'
require_relative 'systemverilog/utility/local_scope'
require_relative 'systemverilog/utility/module_definition'
require_relative 'systemverilog/utility/package_definition'
require_relative 'systemverilog/utility'

require_relative 'systemverilog/component'
require_relative 'systemverilog/feature'
require_relative 'systemverilog/feature_rtl'
require_relative 'systemverilog/feature_ral'
require_relative 'systemverilog/factories'

module RgGen
  module SystemVerilog
    def self.setup(builder, name, sv_feature)
      builder.output_component_registry(name) do
        register_component [
          :register_map, :register_block, :register, :bit_field
        ] do |category|
          component Component, ComponentFactory
          feature sv_feature, FeatureFactory if category != :register_map
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
