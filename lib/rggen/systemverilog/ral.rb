# frozen_string_literal: true

require_relative 'common'
require_relative 'ral/feature'
require_relative 'ral/register_common'

RgGen.setup_plugin :'rggen-sv-ral' do |plugin|
  plugin.version RgGen::SystemVerilog::VERSION

  plugin.register_component :sv_ral do
    component RgGen::SystemVerilog::Common::Component,
              RgGen::SystemVerilog::Common::ComponentFactory
    feature RgGen::SystemVerilog::RAL::Feature,
            RgGen::SystemVerilog::Common::FeatureFactory
  end

  plugin.files [
    'ral/register_block/sv_ral_package',
    'ral/register_block/sv_ral_model',
    'ral/register_file/sv_ral_model',
    'ral/register/type',
    'ral/register/type/external',
    'ral/register/type/indirect',
    'ral/bit_field/type',
    'ral/bit_field/type/rof',
    'ral/bit_field/type/rotrg_rwtrg_wotrg',
    'ral/bit_field/type/rowo_rowotrg',
    'ral/bit_field/type/rwc_rws',
    'ral/bit_field/type/rwe_rwl',
    'ral/bit_field/type/w0trg_w1trg'
  ]
end
