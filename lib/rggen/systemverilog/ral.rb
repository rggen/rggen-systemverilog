# frozen_string_literal: true

require_relative 'common'
require_relative 'ral/feature'
require_relative 'ral/register_common'

module RgGen
  module SystemVerilog
    module RAL
      extend Core::Plugin

      setup_plugin :'rggen-sv-ral' do |plugin|
        plugin.version SystemVerilog::VERSION

        plugin.register_component :sv_ral do
          component Common::Component, Common::ComponentFactory
          feature Feature, Common::FeatureFactory
        end

        plugin.files [
          'ral/bit_field/type',
          'ral/bit_field/type/rof',
          'ral/bit_field/type/rowo',
          'ral/bit_field/type/rwc_rws',
          'ral/bit_field/type/rwe_rwl',
          'ral/bit_field/type/w0trg_w1trg',
          'ral/register/type',
          'ral/register/type/external',
          'ral/register/type/indirect',
          'ral/register_block/sv_ral_model',
          'ral/register_block/sv_ral_package',
          'ral/register_file/sv_ral_model'
        ]
      end
    end
  end
end
