# frozen_string_literal: true

require 'docile'
require 'facets/kernel/attr_singleton'

require_relative 'version'

require_relative 'common/utility/identifier'
require_relative 'common/utility/data_object'
require_relative 'common/utility/interface_instance'
require_relative 'common/utility/interface_port'
require_relative 'common/utility/structure_definition'
require_relative 'common/utility/class_definition'
require_relative 'common/utility/function_definition'
require_relative 'common/utility/local_scope'
require_relative 'common/utility/module_definition'
require_relative 'common/utility/package_definition'
require_relative 'common/utility/source_file'
require_relative 'common/utility'

require_relative 'common/component'
require_relative 'common/feature'
require_relative 'common/factories'

module RgGen
  module SystemVerilog
    module Common
      def self.register_component(builder, name, feature_class)
        builder.output_component_registry(name) do
          register_component [
            :root, :register_block, :register_file, :register, :bit_field
          ] do |category|
            component Component, ComponentFactory
            feature feature_class, FeatureFactory if category != :root
          end
        end
      end

      def self.load_features(features, root)
        features.each { |feature| require File.join(root, feature) }
      end
    end
  end
end
