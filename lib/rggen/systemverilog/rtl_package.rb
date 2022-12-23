# frozen_string_literal: true

require_relative 'common'
require_relative 'rtl_package/feature'

RgGen.setup_plugin :'rggen-sv-rtl-package' do |plugin|
  plugin.version RgGen::SystemVerilog::VERSION

  plugin.register_component :sv_rtl_package do
    component RgGen::SystemVerilog::Common::Component,
              RgGen::SystemVerilog::Common::ComponentFactory
    feature RgGen::SystemVerilog::RTLPackage::Feature,
            RgGen::SystemVerilog::Common::FeatureFactory
  end

  plugin.files [
    'rtl_package/bit_field/sv_rtl_package',
    'rtl_package/register/sv_rtl_package'
  ]
end
