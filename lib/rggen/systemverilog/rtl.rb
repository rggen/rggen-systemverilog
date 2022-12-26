# frozen_string_literal: true

require_relative 'common'
require_relative 'rtl/feature'
require_relative 'rtl/partial_sum'
require_relative 'rtl/register_index'
require_relative 'rtl/register_type'
require_relative 'rtl/indirect_index'
require_relative 'rtl/bit_field_index'
require_relative 'rtl_package/feature'

RgGen.setup_plugin :'rggen-sv-rtl' do |plugin|
  plugin.version RgGen::SystemVerilog::VERSION

  plugin.register_component :sv_rtl do
    component RgGen::SystemVerilog::Common::Component,
              RgGen::SystemVerilog::Common::ComponentFactory
    feature RgGen::SystemVerilog::RTL::Feature,
            RgGen::SystemVerilog::Common::FeatureFactory
  end

  plugin.files [
    'rtl/global/array_port_format',
    'rtl/register_block/sv_rtl_top',
    'rtl/register_block/protocol',
    'rtl/register_block/protocol/apb',
    'rtl/register_block/protocol/axi4lite',
    'rtl/register_block/protocol/wishbone',
    'rtl/register_file/sv_rtl_top',
    'rtl/register/sv_rtl_top',
    'rtl/register/type',
    'rtl/register/type/external',
    'rtl/register/type/indirect',
    'rtl/bit_field/sv_rtl_top',
    'rtl/bit_field/type',
    'rtl/bit_field/type/custom',
    'rtl/bit_field/type/rc_w0c_w1c_wc_woc',
    'rtl/bit_field/type/ro_rotrg',
    'rtl/bit_field/type/rof',
    'rtl/bit_field/type/rol',
    'rtl/bit_field/type/row0trg_row1trg',
    'rtl/bit_field/type/rowo_rowotrg',
    'rtl/bit_field/type/rs_w0s_w1s_ws_wos',
    'rtl/bit_field/type/rw_rwtrg_w1',
    'rtl/bit_field/type/rwc',
    'rtl/bit_field/type/rwe_rwl',
    'rtl/bit_field/type/rws',
    'rtl/bit_field/type/w0crs_w0src_w1crs_w1src_wcrs_wsrc',
    'rtl/bit_field/type/w0t_w1t',
    'rtl/bit_field/type/w0trg_w1trg',
    'rtl/bit_field/type/wo_wo1_wotrg',
    'rtl/bit_field/type/wrc_wrs'
  ]

  plugin.register_component :sv_rtl_package do
    component RgGen::SystemVerilog::Common::Component,
              RgGen::SystemVerilog::Common::ComponentFactory
    feature RgGen::SystemVerilog::RTLPackage::Feature,
            RgGen::SystemVerilog::Common::FeatureFactory
  end

  plugin.files [
    'rtl_package/bit_field/sv_rtl_package',
    'rtl_package/register/sv_rtl_package',
    'rtl_package/register_block/sv_rtl_package'
  ]
end
